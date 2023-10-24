#include <stdio.h>
#include "treetable.h"
#include "Ex3ConcTestSuite/treetable_addConcreteTest.c"
#include "Ex3ConcTestSuite/treetable_get_first_keyConcreteTest.c"
#include "Ex3ConcTestSuite/treetable_get_greater_thanConcreteTest.c"
#include "Ex3ConcTestSuite/treetable_getConcreteTest.c"

int main() {
    TreeTable *table;
    treetable_new(&table);

    int key1 = 1;
    int key2 = 2;

    char value1[] = "aaa"; 
    char value2[] = "bbb";

    treetable_add(table, &key1, value1);
    treetable_add(table, &key2, value2);

    if (treetable_contains_key(table, &key1)){

        void* value;
        treetable_get(table, &key1, &value);
        
        printf("Treetable contains pair => (%d:%s)\n", key1, (char*) value);
    }
    treetable_destroy(table);

    //Testing treetable_add function
    add_test1();
    add_test2();
    add_test3();

     //Testing treetable_get
    tt_get_test1();
    tt_get_test2();
    tt_get_test3();

    //Testing treetable_get_first_key
    get_first_test();

    //Testing treetable_get_greater_than
    get_greater_test1();
    get_greater_test2();
    get_greater_test3();

    return 0;
}
