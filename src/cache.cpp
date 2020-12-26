#include "cache.h"

Cache::Cache(QObject *parent, uint numSets, uint numWays, uint blockSize)
	: QObject(parent)
{
	_numSets = numSets;
	_numWays = numWays;
	_blockSize = blockSize;

	_hits = 0;
	_misses = 0;
	_hitRate = 0.0;
	_missRate = 0.0;
	_numBitsSet = 0;
	_numBitsBlockSize = 0;
	_numBitsTag = 0;
}

void Cache::reset()
{
	// TODO replace assertions with exceptions and error handling
	// or move the error-checking to the frontend
	assert((_numSets == 1) || ((_numSets != 0) && !(_numSets % 2)));
	assert((_blockSize == 1) || ((_blockSize != 0) && !(_blockSize % 2)));

	if (_sets) {
		_sets.reset();
	}

	_hits = 0;
	_misses = 0;
	_hitRate = 0.0;
	_missRate = 0.0;

	updateNumberOfBits();

	_sets = std::make_unique<std::vector<std::unique_ptr<CacheSet>>>(_numSets);
	for (auto &s : *_sets) {
		s = std::make_unique<CacheSet>(_numWays, _blockSize);
	}
	emit cacheUpdated();
}

void Cache::request(uint addr)
{
	uint setAndBlockBits = (addr & ((1 << (_numBitsSet + _numBitsBlockSize + 2)) - 1)) >> 2;
	uint set, block, tag;
	Q_UNUSED(block);
	tag = (addr >> (_numBitsSet + _numBitsBlockSize + 2));
	if (_blockSize > 1) {
		set = setAndBlockBits >> _numBitsBlockSize;
		block = setAndBlockBits & ((1 << _numBitsBlockSize) - 1);
	} else {
		set = setAndBlockBits;
		block = 0;
	}
	CacheSet::RequestResult rc = (*_sets)[set]->request(QString::number(tag, 2).rightJustified(_numBitsTag, '0'));
	if (rc == CacheSet::RequestResult::REQUEST_RESULT_HIT) {
		_hits++;
	} else {
		_misses++;
	}
	_hitRate = float(_hits) / float(_hits + _misses);
	_missRate = 1 - _hitRate;
	emit cacheUpdated();
	emit hitRateChanged();
	emit missRateChanged();
}

bool Cache::getValidField(uint set, uint way)
{
	if (set >= _numSets || way >= _numWays) {
		// TODO error handling
		abort();
	}
	return (*_sets)[set]->getValid(way);
}

QString Cache::getTagField(uint set, uint way)
{
	if (set >= _numSets || way >= _numWays) {
		// TODO error handling
		abort();
	}
	return (*_sets)[set]->getTag(way);
}

std::ostream& operator<<(std::ostream& os, const Cache& c)
{
	std::ios_base::fmtflags iosPrevState(os.flags());
	for (const auto &s : *(c._sets)) {
		os << *s << std::endl;
	}
	os.flags(iosPrevState);
	return os;
}

void Cache::updateNumberOfBits()
{
	_numBitsSet = 0;
	_numBitsBlockSize = 0;
	uint temp;
	temp = _numSets;
	while (temp >>= 1) ++_numBitsSet;
	temp = _blockSize;
	while (temp >>= 1) ++_numBitsBlockSize;
	_numBitsTag = WORD_SIZE - (_numBitsSet + _numBitsBlockSize + 2);
}


uint Cache::numSets() const
{
	return _numSets;
}

void Cache::setNumSets(const uint &numSets)
{
	_numSets = numSets;
	emit numSetsChanged();
}

uint Cache::numWays() const
{
	return _numWays;
}

void Cache::setNumWays(const uint &numWays)
{
	_numWays = numWays;
	emit numWaysChanged();
}

uint Cache::blockSize() const
{
	return _blockSize;
}

void Cache::setBlockSize(const uint &blockSize)
{
	_blockSize = blockSize;
	emit blockSizeChanged();
}

float Cache::hitRate() const
{
	return _hitRate;
}

float Cache::missRate() const
{
	return _missRate;
}
