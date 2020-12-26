#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "cache.h"

int main(int argc, char *argv[])
{
	qmlRegisterType<Cache>("com.cache", 1, 0, "Cache");

	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

	QGuiApplication app(argc, argv);

	QQmlApplicationEngine engine;
	const QUrl url(QStringLiteral("qrc:/main.qml"));
	QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
					 &app, [url](QObject *obj, const QUrl &objUrl) {
		if (!obj && url == objUrl)
			QCoreApplication::exit(-1);
	}, Qt::QueuedConnection);
	engine.load(url);

	/*
	CacheSet c(4, 10);
	Cache d(nullptr, 16, 1, 1);
	//d.request(0x4);
	//d.request(0xC);
	//d.request(0x8);
	// 8.9
	d.request(0x40);
	d.request(0x44);
	d.request(0x48);
	d.request(0x4C);
	d.request(0x70);
	d.request(0x74);
	d.request(0x78);
	d.request(0x7C);
	d.request(0x80);
	d.request(0x84);
	d.request(0x88);
	d.request(0x8C);
	d.request(0x90);
	d.request(0x94);
	d.request(0x98);
	d.request(0x9C);
	d.request(0x00);
	d.request(0x04);
	d.request(0x08);
	d.request(0x0C);
	d.request(0x10);
	d.request(0x14);
	d.request(0x18);
	d.request(0x1C);
	d.request(0x20);
	std::cout << d << std::endl;
	std::cout << "Hit Rate: " << d._hitRate << std::endl;
	std::cout << "Miss Rate: " << d._missRate << std::endl;
	*/

	return app.exec();
}
