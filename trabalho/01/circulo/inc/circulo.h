#ifndef _CIRCULO_H
#define _CIRCULO_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <locale.h>
#include <ctype.h>

struct _coordinates {
  double x;
  double y;
};

struct _circle {
  double radius;
  double area;
};

typedef struct _circle circle;
typedef struct _coordinates coordinates;

#endif
