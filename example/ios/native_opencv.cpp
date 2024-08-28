#include <opencv2/opencv.hpp>
#include "native_opencv.h"
#include <vector>

using namespace cv;
using namespace std;

extern "C"
{
    const char *opencvVersion()
    {
        return CV_VERSION;
    }
}
