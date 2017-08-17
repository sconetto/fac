#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char const *argv[]) {
  int i = 0;
  char *exec;
  const char deli[3] = "./";
  exec = (char *) malloc(sizeof(strlen(argv[0] - 2)));
  printf("# de parametros: %d\n", argc - 1);
  for (i = 0; i < argc; i++) {
    if (i == 0) {
      strcpy(exec, argv[0]);
      exec = strtok(exec, deli);
      printf("Nome do executavel: %s\n", exec);
    } else {
      printf("Parametro #%d: %s\n", i, argv[i]);
    }
  }
  return 0;
}
