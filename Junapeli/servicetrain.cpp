#include "servicetrain.h"

ServiceTrain::ServiceTrain(QString type, bool active): type_(type), isActive_(active),
    MAX_dura(), durability_(), speed_(), price_()
{
    if (type_ == "pumppuresiina") { MAX_dura=50; durability_=50; speed_=2.5; price_=200; }
    else if (type_ == "lättähattu") { MAX_dura=100; durability_=100; speed_=2.9; price_=500; }
    else if (type_ == "höyryveturi") { MAX_dura=100; durability_=100; speed_=4.0; price_=2000; }
    else if (type_ == "luotijuna") { MAX_dura=50; durability_=50; speed_=6.0; price_=10000; }
    else if (type_ == "futuristinenjuna") { MAX_dura=1000; durability_=1000; speed_=10.0; price_=20000; }
}

QString ServiceTrain::trainType() const
{
    return type_;
}

int ServiceTrain::getPrice() const
{
    return price_;
}

double ServiceTrain::getSpeed() const
{
    return speed_;
}

int ServiceTrain::durability() const
{
    return durability_;
}

double ServiceTrain::durabilityInPercent()
{
    double dura = durability_;
    double maxDura = MAX_dura;
    return dura/maxDura;
}

void ServiceTrain::modifyDurability(short amount)
{
    durability_ += amount;
    if (durability_ > MAX_dura) durability_ = MAX_dura;
}

bool ServiceTrain::isActive() const
{
    return isActive_;
}

void ServiceTrain::setActive(bool active)
{
    isActive_ = active;
}

bool ServiceTrain::isUsable()
{
    if (durability_ > 0) return true;
    else return false;
}
