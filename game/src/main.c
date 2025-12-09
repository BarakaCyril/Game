#include "raylib.h"

int main(void) {
    InitWindow(800, 450, "raylib + C + VS Code");
    SetTargetFPS(60);

    while (!WindowShouldClose()) {
        BeginDrawing();
            ClearBackground(RAYWHITE);
            DrawText("Hello from raylib and cyril!", 190, 200, 20, BLACK);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
