#import "BinaryHelper.h"
#include <fstream>
#include <cassert>
#import <CoreFoundation/CoreFoundation.h>
#include <sys/param.h>

/* FileReader class: */

FileReader::FileReader(std::string path, ByteSex byteSex)
    : path(path), byteSex(byteSex)
{
	f = fopen(path.c_str(), "r");
	assert(f);
}

uint32_t FileReader::read32(void)
{
	uint32_t ret = 0;
	fread((void*)&ret, sizeof(ret), 1, f);
    if (byteSex == ByteSexBigEndian) {
        //file is big endian - we are little endian
        //must convert to host endianness
        return CFSwapInt32BigToHost(ret);
    }
    return ret;
}

uint8_t FileReader::read8(void)
{
	uint8_t ret = 0;
	fread((void*)&ret, sizeof(ret), 1, f);
	return ret;
}

void FileReader::read(void* buf, size_t sz)
{
    fread(buf, sz, 1, f);
}

FileReader::~FileReader()
{
	fclose(f);
}

void loadWeights(std::string filePath, std::vector<Eigen::MatrixXf>& weights, std::vector<unsigned int>& architecture)
{
    FileReader f(filePath, ByteSexLittleEndian);
    if (f.read32() == 'wgts') {
        uint32_t nLayers = f.read32();
        architecture.reserve(nLayers);
        for (unsigned i = 0; i < nLayers; i++) {
            architecture.push_back(f.read32());
        }

        uint32_t nWeights = f.read32();
        weights.reserve(nWeights);
        for (unsigned i = 0; i < nWeights; i++) {
            uint32_t rows = f.read32();
            uint32_t cols = f.read32();

            size_t dataSz = sizeof(float) * rows * cols;
            float* data = (float*)malloc(dataSz);
            f.read((void*)data, dataSz);
            Eigen::MatrixXf m = Eigen::Map<Eigen::MatrixXf>(data, rows, cols);
            weights.push_back(m);
            free((void*)data);
        }
    }
}

/*
MINST Database File Formats: 

LABEL FILE (train-labels-idx1-ubyte):
[offset] [type]          [value]          [description]
0000     32 bit integer  0x00000801(2049) magic number (MSB first)
0004     32 bit integer  60000            number of items
0008     unsigned byte   ??               label
0009     unsigned byte   ??               label
........
xxxx     unsigned byte   ??               label
The labels values are 0 to 9.

IMAGE FILE (train-images-idx3-ubyte):
[offset] [type]          [value]          [description]
0000     32 bit integer  0x00000803(2051) magic number
0004     32 bit integer  60000            number of images
0008     32 bit integer  28               number of rows
0012     32 bit integer  28               number of columns
0016     unsigned byte   ??               pixel
0017     unsigned byte   ??               pixel
........
xxxx     unsigned byte   ??               pixel
Pixels are organized row-wise. Pixel values are 0 to 255. 0 means background (white), 255 means foreground (black).
*/

std::vector<std::pair<Eigen::VectorXf, Eigen::VectorXf>> loadDataset(std::string dir, MNISTDatasetType type, uint32_t maxSize)
{
	std::vector<std::pair<Eigen::VectorXf, Eigen::VectorXf>> ret;

	//label file:
	std::string labelPath = dir + (type == MNISTDatasetTypeTest ? "t10k-labels.idx1-ubyte" : "train-labels.idx1-ubyte");
	FileReader lblFile(labelPath, ByteSexBigEndian);
	uint32_t lblMagic = lblFile.read32();
	assert(lblMagic == 0x00000801);

	//images file:
	std::string imgPath = dir + (type == MNISTDatasetTypeTest ? "t10k-images.idx3-ubyte" : "train-images.idx3-ubyte");
	FileReader imgFile(imgPath, ByteSexBigEndian);
	uint32_t imgMagic = imgFile.read32();
	assert(imgMagic == 0x00000803);

	uint32_t count = lblFile.read32();
	assert(count == imgFile.read32());
	size_t imgSize = imgFile.read32() * imgFile.read32();
	count = MIN(count, maxSize);

	for (uint32_t i = 0; i < count; i++)
	{
		Eigen::VectorXf x = Eigen::VectorXf::Zero(imgSize);
		for (uint32_t pi = 0; pi < imgSize; pi++)
			x[pi] = (float)imgFile.read8();
		
		Eigen::VectorXf y = Eigen::VectorXf::Zero(10);
		uint8_t label = lblFile.read8();
		y[label] = 1.f;

		ret.push_back(std::make_pair(x, y));
	}

	return ret;
}
