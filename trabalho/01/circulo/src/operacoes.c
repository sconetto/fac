#include "funcoes.h"
#include "circulo.h"
#include "operacoes.h"

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
