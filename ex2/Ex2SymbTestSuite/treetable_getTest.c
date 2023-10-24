#include "klee/klee.h"
#include <assert.h>
#include "../treetable.h"

#define SIZE 2

int main () {
    //treetable_get symbolic test

    TreeTable *tt;
    treetable_new(&tt);

    int a_key, b_key;
    char a_val[SIZE], b_val[SIZE];
    klee_make_symbolic(&a_key, sizeof(int), "a_key");
    klee_make_symbolic(&b_key, sizeof(int), "b_key");
    klee_make_symbolic(&a_val, sizeof(char)*SIZE, "a_val");
    klee_make_symbolic(&b_val, sizeof(char)*SIZE, "b_val");

    treetable_add(tt, &a_key, a_val);

    assert(tt != NULL);

    void *out;
    assert(treetable_get(tt, &a_key, &out) == CC_OK && strcmp(out, a_val) == 0);
    if (a_key != b_key) assert(treetable_get(tt, &b_key, &out) == CC_ERR_KEY_NOT_FOUND);

    treetable_destroy(tt);

    return 0;
}