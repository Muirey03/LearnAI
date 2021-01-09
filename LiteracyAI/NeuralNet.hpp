#pragma once
#include <vector>
#include <utility>
#include <functional>
#include <Eigen/Dense> //Eigen library

#define DEFAULT_ACTIVATION &sigmoid
#define DEFAULT_D_ACTIVATION &d_sigmoid

float sigmoid(float x);
float d_sigmoid(float x);

class NeuralNet
{
protected:
	//array of activation vectors
	std::vector<Eigen::VectorXf> _layers;
	//array of matrices, row = vector of weights for node in li + 1
	//_weights[li](ni, prevNi) is the weight for the connection between the node at index prevNi in layer li and the node at index ni in layer li + 1
	std::vector<Eigen::MatrixXf> _weights;
	//array of z vectors
	std::vector<Eigen::VectorXf> _zLayers;
	//the activation function (default is sigmoid):
	std::function<float(float)> _f_activation;
	//the derivitive of the activation function (defaults is d_sigmoid):
	std::function<float(float)> _f_d_activation;
public:
	//layers does not include bias nodes
	NeuralNet(std::vector<unsigned> layers, std::function<float(float)> f_activation = DEFAULT_ACTIVATION, std::function<float(float)> f_d_activation = DEFAULT_D_ACTIVATION, std::vector<Eigen::MatrixXf>* weights = nullptr);
	NeuralNet(std::vector<unsigned> layers, std::vector<Eigen::MatrixXf>* weights) : NeuralNet(layers, DEFAULT_ACTIVATION, DEFAULT_D_ACTIVATION, weights) { };
	Eigen::VectorXf go(Eigen::VectorXf& inputs);
	float train(std::vector<std::pair<Eigen::VectorXf, Eigen::VectorXf>>& trainingData, float learningRate, size_t batchSize = 10);
	std::vector<Eigen::MatrixXf>& getWeights(void) { return _weights; };
	void setWeights(std::vector<Eigen::MatrixXf>& weights) { _weights = weights; };
	static float cost(Eigen::VectorXf& y, Eigen::VectorXf& h);
	static unsigned findLargest(Eigen::VectorXf& y);
protected:
	float trainBatch(std::vector<std::pair<Eigen::VectorXf, Eigen::VectorXf>>& batch, float learningRate);
	std::vector<Eigen::MatrixXf> backProp(Eigen::VectorXf& x, Eigen::VectorXf& y, float* outCost = nullptr);
	static Eigen::VectorXf d_cost(Eigen::VectorXf& y, Eigen::VectorXf& h);
	inline Eigen::VectorXf& v_activation(Eigen::VectorXf& vec, unsigned startRow);
	inline Eigen::VectorXf& v_d_activation(Eigen::VectorXf& vec, unsigned startRow);
};
