#ifndef CACHE_H
#define CACHE_H

#include <QObject>
#include <stdlib.h>
#include <iostream>
#include <memory>
#include "cacheset.h"
#include <QString>

class Cache : public QObject
{
	Q_OBJECT
	Q_PROPERTY(uint numSets READ numSets WRITE setNumSets NOTIFY numSetsChanged)
	Q_PROPERTY(uint numWays READ numWays WRITE setNumWays NOTIFY numWaysChanged)
	Q_PROPERTY(uint blockSize READ blockSize WRITE setBlockSize NOTIFY blockSizeChanged)
	Q_PROPERTY(float hitRate READ hitRate NOTIFY hitRateChanged)
	Q_PROPERTY(float missRate READ missRate NOTIFY missRateChanged)
	// TODO switch to the new qml type registration system
	// once it's stable enough
	// QML_ELEMENT
public:
	explicit Cache(QObject *parent = nullptr, uint nSets=1, uint nWays=1,
				   uint blockSize=1);

	Q_INVOKABLE void reset();
	Q_INVOKABLE void request(uint requestAddr);
	Q_INVOKABLE bool getValidField(uint set, uint way);
	Q_INVOKABLE QString getTagField(uint set, uint way);

	friend std::ostream& operator<<(std::ostream& os, const Cache& c);

	uint numSets() const;
	void setNumSets(const uint &numSets);

	uint numWays() const;
	void setNumWays(const uint &numWays);

	uint blockSize() const;
	void setBlockSize(const uint &blockSize);

	float hitRate() const;

	float missRate() const;

private:
	void updateNumberOfBits();

	std::unique_ptr<std::vector<std::unique_ptr<CacheSet>>> _sets;

	uint _numSets;
	uint _numWays;
	uint _blockSize;

	float _hitRate;
	float _missRate;

	uint _numBitsSet;
	uint _numBitsBlockSize;
	uint _numBitsTag;
	uint64_t _hits;
	uint64_t _misses;

	const uint WORD_SIZE = 32;

signals:
	void numSetsChanged();
	void numWaysChanged();
	void blockSizeChanged();
	void hitRateChanged();
	void missRateChanged();
	void cacheUpdated();
};

#endif // CACHE_H
