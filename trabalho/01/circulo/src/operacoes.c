#include "funcoes.h"
#include "circulo.h"
#include "operacoes.h"
#define PI 3.14159265

int verify_collinearity(coordinates a, coordinates b, coordinates c) {
  double matrix[MATRIX_SIZE][MATRIX_SIZE];
  int i;
  int j;
  double determinant = 0.0;
  int count = MATRIX_SIZE;

  for (i = 0; i < count; i++) {
    for (j = 0; j < count; j++) {
      if (j == count - 1) {
        matrix[i][j] = 1.0;
      }
      if (i == 0) {
        if (j == 0) {
          matrix[i][j] = a.x;
        } else if (j == 1) {
          matrix[i][j] = a.y;
        }
      } else if (i == 1) {
        if (j == 0) {
          matrix[i][j] = b.x;
        } else if (j == 1) {
          matrix[i][j] = b.y;
        }
      } else if (i == 2) {
        if (j == 0) {
          matrix[i][j] = c.x;
        } else if (j == 1) {
          matrix[i][j] = c.y;
        }
      }
    }
  }

  determinant = (((matrix[0][0]*matrix[1][1]*matrix[2][2]) + (matrix[0][1]*matrix[1][2]*matrix[2][0]) + (matrix[0][2]*matrix[1][0]*matrix[2][1]))-((matrix[2][0]*matrix[1][1]*matrix[0][2]) + (matrix[2][1]*matrix[1][2]*matrix[0][0]) + (matrix[2][2]*matrix[1][0]*matrix[0][1])));
  return (determinant == 0);
}

circle verify_trinomial(double a, double b, double c) {
  /* x² + y² + ax + by + c = 0*/
  double aux[2];
  int verifier[2];
  circle circle;
  c = c * (-1.0);
  if (fmod(a, 2.0) == 0.0) {
    aux[0] = pow((a / 2.0), 2);
  }
  if (fmod(b, 2.0) == 0.0) {
    aux[1] = pow((b / 2.0), 2);
  }

  if (a < 0) {
    verifier[0] = 0;
  }
  if (b < 0) {
    verifier[1] = 0;
  }

  /* printf("%.2f %.2f\n", aux[0], aux[1]); */
  c = c + aux[0] + aux [1];
  aux[0] = sqrt(aux[0]);
  aux[1] = sqrt(aux[1]);
  c = sqrt(c);
  /* printf("ponto x: %.2f\nponto y: %.2f\nraio: %.2f\n", aux[0], aux[1], c); */
  if(!verifier[0]) {
    circle.center.x = aux[0] * (-1.0);
  } else {
    circle.center.x = aux[0];
  }
  if (!verifier[1]) {
    circle.center.y = aux[1] * (-1.0);
  } else {
    circle.center.y = aux[1];
  }
  if (circle.center.x == -0.0) {
    circle.center.x = 0.0;
  }
  if (circle.center.y == -0.0) {
    circle.center.y = 0.0;
  }
  circle.radius = c;
  circle.area = ((PI) * pow(c, 2));
  return circle;
}
