#include "funcoes.h"
#include "circulo.h"
#include "operacoes.h"

int main(void) {
  int collinearity;
  coordinates point_1;
  coordinates point_2;
  coordinates point_3;
  circle circle;

  point_1 = read_point();
  point_2 = read_point();
  point_3 = read_point();

  collinearity = verify_collinearity(point_1, point_2, point_3);
  if (!collinearity) {
    circle = define_center(point_1, point_2, point_3);
    print_radius(circle);
  } else {
    printf("Circulo nao viavel.\n");
  }
  return 0;
}
