#include "klee/klee.h"
#include <assert.h>
#include "treetable.h"

void test1();

int main () {
    //treetable_get_first_key test

    test1();

    return 0;
}

void test1() {
    TreeTable *tt;
    treetable_new(&tt);

    int a_key = 0, a_val = 0;
    void *out;

    assert(treetable_get_first_key(tt, &out) == CC_ERR_KEY_NOT_FOUND);
    treetable_add(tt, &a_key, &a_val);

    assert(tt != NULL);

    assert(treetable_get_first_key(tt, &out) == CC_OK && out == &a_key);

    treetable_destroy(tt);
}