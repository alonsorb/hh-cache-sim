#ifndef CACHESET_H
#define CACHESET_H

#include <stdlib.h>
#include <iostream>
#include <vector>
#include <memory>
#include <list>
#include <utility>
#include <QString>

class CacheSet
{
public:
	enum RequestResult {
		REQUEST_RESULT_HIT,
		REQUEST_RESULT_MISS,
		REQUEST_RESULT_MISS_INVALID,
		REQUEST_RESULT_MISS_REPLACED
	};

	explicit CacheSet(uint numWays=1, uint blockSize=1);
	CacheSet::RequestResult request(QString tag);
	friend std::ostream& operator<<(std::ostream& os, const CacheSet& c);
	bool getValid(uint way);
	QString getTag(uint way);
private:
	uint _numWays;
	uint _blockSize;
	std::vector<std::pair<bool, QString>> _ways;
	std::list<uint> _lruList;
};

#endif // CACHESET_H
