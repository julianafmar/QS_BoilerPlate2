#include "klee/klee.h"
#include <assert.h>
#include "treetable.h"

int main () {
    //treetable_get test

    TreeTable *tt;
    treetable_new(&tt);

    int a_key = 16777216, a_val = 0, b_key = 0, b_val = 0;

    treetable_add(tt, &a_key, &a_val);
    //treetable_add(tt, b_key, b_val);

    assert(tt != NULL);

    void *out;
    assert(treetable_get(tt, &a_key, &out) == CC_OK && out == &a_val);
    if (a_key != b_key) assert(treetable_get(tt, &b_key, &out) == CC_ERR_KEY_NOT_FOUND);

    treetable_destroy(tt);

    return 0;
}