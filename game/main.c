#define SDL_MAIN_USE_CALLBACKS 1
#include <SDL3/SDL.h>
#include <SDL3/SDL_main.h>

static SDL_Window *dark_window;
static SDL_Renderer *dark_renderer;

SDL_AppResult SDL_AppInit(void **app_state, int argc, char **argv) {
    (void)app_state;
    (void)argc;
    (void)argv;

    if (!SDL_Init(SDL_INIT_VIDEO)) {
        SDL_Log("SDL_Init failed: %s", SDL_GetError());
        return SDL_APP_FAILURE;
    }

    if (!SDL_CreateWindowAndRenderer("2Ddark", 768, 768, 0, &dark_window, &dark_renderer)) {
        SDL_Log("SDL_CreateWindowAndRenderer failed: %s", SDL_GetError());
        return SDL_APP_FAILURE;
    }

    return SDL_APP_CONTINUE;
}

SDL_AppResult SDL_AppEvent(void *app_state, SDL_Event *event) {
    (void)app_state;

    if (event->type == SDL_EVENT_QUIT) {
        return SDL_APP_SUCCESS;
    }

    return SDL_APP_CONTINUE;
}

SDL_AppResult SDL_AppIterate(void *app_state) {
    (void)app_state;

    (void)SDL_SetRenderDrawColor(dark_renderer, 8, 7, 12, SDL_ALPHA_OPAQUE);
    (void)SDL_RenderClear(dark_renderer);
    SDL_RenderPresent(dark_renderer);
    return SDL_APP_CONTINUE;
}

void SDL_AppQuit(void *app_state, SDL_AppResult result) {
    (void)app_state;
    (void)result;

    SDL_DestroyRenderer(dark_renderer);
    SDL_DestroyWindow(dark_window);
    SDL_Quit();
}
