#include "medals.h"

Medals::Medals(QObject *parent): QObject(parent)
{

}

void Medals::saveMedals(QVariantList medals)
{
    QFile file(filename_);

    if (!file.open(QFile::WriteOnly | QFile::Text))
    {
        std::cout << "Could not open file for writing" << std::endl;
        return;
    }

    QTextStream out(&file);
    QString writeText;

    for (QVariantList::iterator j = medals.begin(); j != medals.end(); j++)
    {
        writeText = writeText + (*j).toString() + "!";

    }

    out << writeText;
    file.flush();
    file.close();
}

void Medals::readMedals()
{
    QFile readFile(filename_);
    if (!readFile.open(QFile::ReadOnly | QFile::Text))
    {
        std::cout << "Could not open file for reading" << std::endl;
        return;
    }

    QTextStream in(&readFile);
    QString readText = in.readAll();
    QString charString;

    for(QString::iterator it = readText.begin(); it != readText.end(); ++it) {
        if (*it == "!")
        {
            savedMedals_.append(charString);
            charString.clear();
        }
        else
        {
            charString = charString + *it;
        }
    }
    readFile.flush();
    readFile.close();
}

QVariantList Medals::getMedals()
{
    return savedMedals_;
}



