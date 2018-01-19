#include "passengertrain.h"

PassengerTrain::PassengerTrain(QObject *train): train_(train), durability_(100)
{
}

bool PassengerTrain::isUsable()
{
    if (durability_ > 0) return true;
    else return false;
}

int PassengerTrain::durability() const
{
    return durability_;
}

void PassengerTrain::modifyDurability(short amount)
{
    durability_ += amount;
}

QObject *PassengerTrain::getObject() const
{
    return train_;
}
