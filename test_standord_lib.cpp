/**
 * WeatherStatisticsMain.cpp by Olivia Stone for Code Clinic: C++
 **/

#include <iostream>
#include <string>

// #include "WeatherStatistics.hpp"

// wqs using the standord c++ lib
#include "util/strlib.h"
#include <bits/stdc++.h>
#include <fmt/format.h>

using namespace fmt;
using namespace std;

int main()
{
    //wqs below
    string data = "a,b,c";
    Vector<string> components = stringSplit(data, ",");
    print("components is {}\n ", components);
    // [from "strlib.h"]:
    // python "asdfADF".lower()
    string data = "ABC";
    cout << toLowerCase(data) << endl; // prints abc

    //wqs above
}