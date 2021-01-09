#include "NeuralNet.hpp"
#include <stdexcept>
#include <iostream>
#include <cmath>
#include <algorithm>
#include <time.h>

#pragma mark Math

float sigmoid(float x)
{
	return 1.f / (1.f + exp(-x));
}

float d_sigmoid(float x)
{
	return sigmoid(x) * (1 - sigmoid(x));
}

#define DEBUG_LOG 1

#if DEBUG_LOG
static unsigned debugSuccesses = 0;
#endif

NeuralNet::NeuralNet(std::vector<unsigned> layers, std::function<float(float)> f_activation, std::function<float(float)> f_d_activation, std::vector<Eigen::MatrixXf>* weights)
	: _f_activation(f_activation), _f_d_activation(f_d_activation)
{
	size_t noLayers = layers.size();
	_layers.reserve(noLayers);
	for (unsigned li = 0; li < noLayers; li++)
	{
		unsigned layerSize = layers[li];
		bool outputLayer = (li == noLayers - 1);
		//make room for bias node when not output layer
		if (!outputLayer) layerSize++;
		//initialise layer with empty vector
		_layers.push_back(Eigen::VectorXf::Constant(layerSize, 0.f));
		//initialise bias node when not output layer
		if (!outputLayer) _layers[li][0] = 1.f;
	}
	_zLayers = _layers;

	if (weights)
	{
		_weights = *weights;
	}
	else
	{
		//initialise random weights:
		std::srand((unsigned int)time(0));
		_weights.reserve(noLayers - 1);
		for (unsigned i = 1; i < noLayers; i++)
		{
			unsigned prevCount = layers[i - 1] + 1; //account for bias node
			unsigned& count = layers[i];
			_weights.push_back(Eigen::MatrixXf::Random(count, prevCount));
		}
	}
}

//Forward propogation:
Eigen::VectorXf NeuralNet::go(Eigen::VectorXf& inputs)
{
	#define ERR(msg) do { throw std::runtime_error(msg); return Eigen::VectorXf::Constant(1, 0.f); } while (0)

	//sanity checks
	if (_layers.size() < 2)
		ERR("Fewer than 2 layers in network is illegal!");

	//fill inputs:
	//(ignoring node 0, the bias node)
	_layers[0].block(1, 0, inputs.rows(), 1) = inputs;
	_zLayers[0] = _layers[0];
	
	size_t noLayers = _layers.size();
	for (unsigned li = 0; li < noLayers - 1; li++)
	{
		//don't overwrite bias node when layer != output layer
		bool outputLayer = ((li + 1) == noLayers - 1);
		unsigned startRow = outputLayer ? 0 : 1;
		//matrix of weights mapping li to li+1
		Eigen::MatrixXf& W = _weights[li];
		//vector of activations for layer li
		Eigen::VectorXf& a = _layers[li];
		//vector of activations for layer li+1
		Eigen::VectorXf& z = _layers[li+1];

		z.block(startRow, 0, z.rows() - startRow, z.cols()) = W * a;
		//store z in zLayers array to be used in back propogation
		_zLayers[li+1] = z;

		//apply activation to every value in z
		//(apart from the bias node when z != output layer)
		v_activation(z, startRow);
	}

	//return last layer
	return _layers[noLayers - 1];

	#undef ERR
}

//create a neural network fitted to a data set
float NeuralNet::train(std::vector<std::pair<Eigen::VectorXf, Eigen::VectorXf>>& trainingData, float learningRate, size_t batchSize)
{
	float avCost = 0.f;

	#if DEBUG_LOG
	debugSuccesses = 0;
	#endif

	//split training data into batches:
	unsigned batchCnt = ceil((float)trainingData.size() / (float)batchSize);
	
	for (unsigned bi = 0; bi < batchCnt; bi++)
	{
		unsigned startI = bi * batchSize;
		size_t currentBatchSz = std::min<unsigned>(batchSize, trainingData.size() - startI);
		std::vector<std::pair<Eigen::VectorXf, Eigen::VectorXf>> batch(trainingData.begin() + startI, trainingData.begin() + startI + currentBatchSz);

		//train on each batch:
		avCost += trainBatch(batch, learningRate);
	}
	avCost /= batchCnt;

	#if DEBUG_LOG
	std::cout << debugSuccesses << "/" << trainingData.size() << std::endl;
	#endif

	return avCost;
}

//train a batch of training data using backpropogation and gradient descent
float NeuralNet::trainBatch(std::vector<std::pair<Eigen::VectorXf, Eigen::VectorXf>>& batch, float learningRate)
{
	float avCost = 0.f;

	//initialise nabla array with empty matrices:
	std::vector<Eigen::MatrixXf> nabla;
	nabla.reserve(_weights.size());
	for (unsigned wi = 0; wi < _weights.size(); wi++)
		nabla.push_back(Eigen::MatrixXf::Constant(_weights[wi].rows(), _weights[wi].cols(), 0.f));

	//backpropogation:
	//(get a cumulative nabla over all items in the batch)
	for (unsigned bi = 0; bi < batch.size(); bi++)
	{
		Eigen::VectorXf& x = batch[bi].first;
		Eigen::VectorXf& y = batch[bi].second;

		float c = 0.f;
		std::vector<Eigen::MatrixXf> delta = backProp(x, y, &c);
		for (unsigned di = 0; di < delta.size(); di++)
			nabla[di] += delta[di];

		avCost += c;
	}
	avCost /= batch.size();

	//gradient descent:
	for (unsigned wi = 0; wi < _weights.size(); wi++)
		_weights[wi] -= (learningRate / batch.size()) * nabla[wi];

	return avCost;
}

std::vector<Eigen::MatrixXf> NeuralNet::backProp(Eigen::VectorXf& x, Eigen::VectorXf& y, float* outCost)
{
	size_t noWeights = _weights.size();
	size_t noLayers = _layers.size();

	std::vector<Eigen::MatrixXf> nabla;

	//initialise with empty matrices
	nabla.reserve(noWeights);
	for (unsigned i = 0; i < noWeights; i++)
		nabla.push_back(Eigen::MatrixXf::Constant(_weights[i].rows(), _weights[i].cols(), 0.f));
	
	//forward propogation:
	Eigen::VectorXf h = go(x);

	//DEBUG:
	#if DEBUG_LOG
	if (findLargest(h) == findLargest(y)) debugSuccesses++;
	#endif

	//return cost:
	if (outCost)
		*outCost = cost(y, h);
	
	/* Back Propogation: */
	//(this is the complicated calculus stuff)
	//delta = how much the activations need to change
	//nabla = how much the weights need to change
	//last layer:
	Eigen::VectorXf delta = d_cost(y, h).cwiseProduct(v_d_activation(_zLayers[noLayers - 1], 0));
	//(no need to remove bias node delta as output layer has no bias node)
	nabla[noWeights - 1] = delta * _layers[noLayers - 2].transpose();

	//start at second-last layer
	for (unsigned li = noLayers - 2; li > 0; li--)
	{
		delta = (_weights[li].transpose() * delta).cwiseProduct(v_d_activation(_zLayers[li], 0));
		delta = delta.tail(delta.size() - 1); //remove bias node delta as that can't be changed

		nabla[li - 1] = (_layers[li - 1] * delta.transpose()).transpose();
	}

	return nabla;
}

float NeuralNet::cost(Eigen::VectorXf& y, Eigen::VectorXf& h)
{
	float c = 0.f;
	for (unsigned i = 0; i < y.size(); i++)
		c += pow((h[i] - y[i]), 2);
	return c;
}

Eigen::VectorXf NeuralNet::d_cost(Eigen::VectorXf& y, Eigen::VectorXf& h)
{
	return (2 * (h - y));
}

//find the largest index in a vector of outputs
unsigned NeuralNet::findLargest(Eigen::VectorXf& y)
{
	unsigned ret = 0;
	float largest = 0.f;
	for (unsigned i = 0; i < y.size(); i++)
	{
		if (i == 0 || y[i] > largest)
		{
			ret = i;
			largest = y[i];
		}
	}
	return ret;
}

//apply activation function to every value in the vector, starting at startRow
Eigen::VectorXf& NeuralNet::v_activation(Eigen::VectorXf& vec, unsigned startRow)
{
	size_t count = vec.size();
	for (unsigned i = startRow; i < count; i++)
		vec[i] = _f_activation(vec[i]);
	return vec;
}

//apply d_activation function to every value in the vector, starting at startRow
Eigen::VectorXf& NeuralNet::v_d_activation(Eigen::VectorXf& vec, unsigned startRow)
{
	size_t count = vec.size();
	for (unsigned i = startRow; i < count; i++)
		vec[i] = _f_d_activation(vec[i]);
	return vec;
}
