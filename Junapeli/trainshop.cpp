#include "trainshop.h"
#include <QDebug>

TrainShop::TrainShop(): coupons_(100)
{
}

int TrainShop::getCoupons() const
{
    return coupons_;
}

void TrainShop::trainPurchased(QString type, int price)
{
    coupons_ -= price;
    emit trainTypePurchased(type);
    emit couponsChanged(coupons_);
}

void TrainShop::repair(short price)
{
    coupons_ -= price;
    emit trainRepaired();
    emit couponsChanged(coupons_);
}

void TrainShop::addCoupons()
{
    coupons_ += 200;
    emit couponsChanged(coupons_);
    qDebug() << "kupongit: " << coupons_;
}
