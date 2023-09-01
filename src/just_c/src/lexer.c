#include <stdio.h>
#include <stdlib.h>

char* read_source(const char* file_path) {
    FILE* file = fopen(file_path, "r");
    if (file == NULL) {
        fprintf(stderr, "Error opening file: %s\n", file_path);
        return NULL;
    }

    // Determine the file size
    fseek(file, 0, SEEK_END);
    long file_size = ftell(file);
    rewind(file);

    // Allocate memory for the file content
    char* content = (char*)malloc(file_size + 1);
    if (content == NULL) {
        fprintf(stderr, "Memory allocation failed.\n");
        fclose(file);
        return NULL;
    }

    // Read the file content
    size_t read_size = fread(content, sizeof(char), file_size, file);
    if (read_size != file_size) {
        fprintf(stderr, "Error reading file: %s\n", file_path);
        fclose(file);
        free(content);
        return NULL;
    }

    // Null-terminate the content
    content[file_size] = '\0';

    fclose(file);
    return content;
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <file_path>\n", argv[0]);
        return 1;
    }

    const char* file_path = argv[1];
    char* content = read_source(file_path);
    if (content != NULL) {
        printf("File content:\n%s\n", content);
        free(content);
    }

    return 0;
}
