#include "cacheset.h"

CacheSet::CacheSet(uint numWays, uint blockSize)
{
	_numWays = numWays;
	_blockSize = blockSize;

	_ways = std::vector<std::pair<bool, QString>>(_numWays);
	_lruList = std::list<uint>();
}

CacheSet::RequestResult CacheSet::request(QString tag)
{
	// No range-based for loops that keep an index var :'(
	for (size_t i = 0; i < _numWays; i++) {
		if (tag == _ways[i].second) {
			if (_ways[i].first) {
				_lruList.remove(i);
				_lruList.push_back(i);
				return RequestResult::REQUEST_RESULT_HIT;
			} else {
				_ways[i].first = true;
				_lruList.remove(i);
				_lruList.push_back(i);
				return RequestResult::REQUEST_RESULT_MISS_INVALID;
			}
		}
	}
	for (size_t i = 0; i < _numWays; i++) {
		if (!_ways[i].first) {
			_ways[i] = std::make_pair(true, tag);
			_lruList.push_back(i);
			return RequestResult::REQUEST_RESULT_MISS;
		}
	}
	auto leastUsed = _lruList.front();
	_lruList.pop_front();
	_ways[leastUsed] = std::make_pair(true, tag);
	_lruList.push_back(leastUsed);
	return REQUEST_RESULT_MISS_REPLACED;
}

bool CacheSet::getValid(uint way)
{
	return _ways[way].first;
}

QString CacheSet::getTag(uint way)
{
	return _ways[way].second;
}

std::ostream& operator<<(std::ostream& os, const CacheSet& c)
{
	//std::ios_base::fmtflags iosPrevState(os.flags());
	//os << std::hex << std::uppercase;
	for (const auto &w : c._ways) {
		os << w.first << "|0x" << w.second.toStdString() << '\t';
	}
	//os.flags(iosPrevState);
	return os;
}
