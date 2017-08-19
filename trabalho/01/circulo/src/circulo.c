#include "funcoes.h"
#include "circulo.h"
#include "operacoes.h"

circle define_center(coordinates a, coordinates b, coordinates c) {
  double xdouble[3]; /* X² - X ao quadrado */
  double ydouble[3]; /* Y² - Y ao quadrado */
  double matrix_pattern[3][3] = {
    {a.x, a.y, 1},
    {b.x, b.y, 1},
    {c.x, c.y, 1}
  };
  double matrix[4][3][3]; /* Todas as matrizes necessárias para o cálculo */
  double result[3]; /* Resultado da soma dos quadrados */
  double s[3]; /* Conjunto solução S */
  /*coordinates center; Coordenda resultado do centro */
  circle circle; /* Circulo para armazenar as informações */
  double determinant[4];
  int i, j, k = 0;

  xdouble[0] = pow(a.x,2);
  ydouble[0] = pow(a.y,2);
  xdouble[1] = pow(b.x,2);
  ydouble[1] = pow(b.y,2);
  xdouble[2] = pow(c.x,2);
  ydouble[2] = pow(c.y,2);

  result[0] = (xdouble[0] + ydouble[0]) * (-1.0);
  result[1] = (xdouble[1] + ydouble[1]) * (-1.0);
  result[2] = (xdouble[2] + ydouble[2]) * (-1.0);

  for (i = 0; i < 4; i++) {
    for (j = 0; j < 3; j++) {
      for (k = 0; k < 3; k++) {
        matrix[i][j][k] = matrix_pattern[j][k];
      }
    }
  }

  for (i = 0; i < 4; i++) {
    if (i == 1) {
      matrix[i][0][0] = result[0];
      matrix[i][1][0] = result[1];
      matrix[i][2][0] = result[2];
    } else if (i == 2) {
      matrix[i][0][1] = result[0];
      matrix[i][1][1] = result[1];
      matrix[i][2][1] = result[2];
    } else if (i == 3) {
      matrix[i][0][2] = result[0];
      matrix[i][1][2] = result[1];
      matrix[i][2][2] = result[2];
    }
  }


  /*for (i = 0; i < 4; i++) {
    printf("Matriz %d\n", i);
    for (j = 0; j < 3; j++) {
      for (k = 0; k < 3; k++) {
        printf("%.2f ", matrix[i][j][k]);
      }
      printf("\n");
    }
    printf("\n\n");
  }*/

  for (i = 0; i < 4; i++) {
    determinant[i] = (((matrix[i][0][0]*matrix[i][1][1]*matrix[i][2][2]) + (matrix[i][0][1]*matrix[i][1][2]*matrix[i][2][0]) + (matrix[i][0][2]*matrix[i][1][0]*matrix[i][2][1]))-((matrix[i][2][0]*matrix[i][1][1]*matrix[i][0][2]) + (matrix[i][2][1]*matrix[i][1][2]*matrix[i][0][0]) + (matrix[i][2][2]*matrix[i][1][0]*matrix[i][0][1])));
    /* printf("det[%d]: %.2f\n", i, determinant[i]); */
  }

  s[0] = determinant[1]/determinant[0];
  s[1] = determinant[2]/determinant[0];
  s[2] = determinant[3]/determinant[0];

  /* printf("%.2f %.2f %.2f\n", s[0], s[1], s[2]); */
  circle = verify_trinomial(s[0], s[1], s[2]);

  /*if (s[0] == 0 && s[1] == 0) {
    center.x = 0.0;
    center.y = 0.0;
  } else if (s[0] == 0 && s[1] != 0) {
    center.x = 0.0;
    center.y = circle.center.y;
  } else if (s[0] != 0 && s[1] == 0) {
    center.x = circle.center.x;
    center.y = 0.0;
  } else {
    center.x = circle.center.x;
    center.y = circle.center.y;
  }*/
  return circle;
}
