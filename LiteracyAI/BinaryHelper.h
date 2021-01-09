#import <Foundation/Foundation.h>
#include <vector>
#include <Eigen/Sparse>
#include <string>
#include <utility>
#include <cstdint>
#include <cstdio>

typedef NS_ENUM(NSInteger, ByteSex) {
    ByteSexLittleEndian,
    ByteSexBigEndian
};

class FileReader
{
protected:
	std::string path;
    ByteSex byteSex;
	FILE* f = NULL;

public:
	FileReader(std::string path, ByteSex byteSex);
	uint32_t read32(void);
	uint8_t read8(void);
    void read(void* buf, size_t sz);
	~FileReader();
};

typedef enum
{
	MNISTDatasetTypeTrain,
	MNISTDatasetTypeTest
} MNISTDatasetType;

void loadWeights(std::string filePath, std::vector<Eigen::MatrixXf>& weights, std::vector<unsigned int>& architecture);
std::vector<std::pair<Eigen::VectorXf, Eigen::VectorXf>> loadDataset(std::string dir, MNISTDatasetType type, uint32_t maxSize = UINT32_MAX);
