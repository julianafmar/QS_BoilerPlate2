#include "klee/klee.h"
#include <assert.h>
#include "../treetable.h"

void test1();
void test2();
void test3();

int main () {
    //treetable_greater_than test

    test1();
    test2();
    test3();
    
    return 0;
}

void test1() {
    
    TreeTable *tt;
    treetable_new(&tt);

    int a_key = 0, a_val = 0, b_key = 0, b_val = 0;

    void *out;
    assert(treetable_get_greater_than(tt, &a_key, &out) == CC_ERR_KEY_NOT_FOUND);
    
    treetable_add(tt, &a_key, &a_val);
    treetable_add(tt, &b_key, &b_val);

    assert(tt != NULL);
    
    assert(treetable_get_greater_than(tt, &b_key, &out) == CC_OK && out == NULL);

    treetable_destroy(tt);
}

void test2() {
    
    TreeTable *tt;
    treetable_new(&tt);

    int a_key = 1, a_val = 0, b_key = 0, b_val = 0;

    void *out;
    assert(treetable_get_greater_than(tt, &a_key, &out) == CC_ERR_KEY_NOT_FOUND);
    
    treetable_add(tt, &a_key, &a_val);
    treetable_add(tt, &b_key, &b_val);

    assert(tt != NULL);
    
    assert(treetable_get_greater_than(tt, &b_key, &out) == CC_OK && out == &a_key);

    treetable_destroy(tt);
}


void test3() {
    TreeTable *tt;
    treetable_new(&tt);

    int a_key = -1979711488, a_val = 0, b_key = 0, b_val = 0;

    void *out;
    assert(treetable_get_greater_than(tt, &a_key, &out) == CC_ERR_KEY_NOT_FOUND);
    
    treetable_add(tt, &a_key, &a_val);
    treetable_add(tt, &b_key, &b_val);

    assert(tt != NULL);
    
    assert(treetable_get_greater_than(tt, &b_key, &out) == CC_OK && out == NULL);

    treetable_destroy(tt);
}