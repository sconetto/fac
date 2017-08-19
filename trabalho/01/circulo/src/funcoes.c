#include "funcoes.h"
#include "circulo.h"
#include "operacoes.h"

coordinates read_point() {
  coordinates point;
  point.x = point.y = 0;
  scanf("%lf %lf", &point.x, &point.y);
  return point;
}

void print_radius(circle circle) {
  printf("Raio: %.3f\n", circle.radius);
  printf("Centro: (%.3f, %.3f).\n", circle.center.x, circle.center.y);
  return;
}

void print_area(circle circle) {
  printf("Area: %.3f.\n", circle.area);
  return;
}
