#include "main.h"
#include <fstream>

extern "C"
{
void* DLL_EXPORT InitDevice(ALCdevice* dev){
    fstream file("openal.txt", ios::out | ios::binary);
    file << dev << '\n';
    ALCdevice* _dev = alcOpenDevice(NULL);
    memcpy(&dev, &_dev, sizeof(ALCdevice*));
    file << dev;
}

void* DLL_EXPORT InitContext(ALCdevice* dev, ALCcontext* ctx){
    ctx = alcCreateContext(dev, NULL);
}

int DLL_EXPORT DestroyDevice(ALCdevice* dev, ALCcontext* ctx){
    alcMakeContextCurrent(NULL);
    alcDestroyContext(ctx);
    alcCloseDevice(dev);
}

int DLL_EXPORT PlayAudio(ALCcontext* ctx, LPSTR filename,
                          int sourceX, int sourceY, int sourceZ,
                          int listenerX, int listenerY, int listenerZ,
                          int sourceVX, int sourceVY, int sourceVZ,
                          int listenerVX, int listenerVY, int listenerVZ){

    ALfloat sourcePos[] = {sourceX / 2.0, sourceY / 2.0, sourceZ / 2.0};
    ALfloat sourceVel[] = {sourceVX / 1.0, sourceVY / 1.0, sourceVZ / 1.0};
    ALfloat listenerPos[] = {listenerX / 2.0, listenerY / 2.0, listenerZ / 2.0};
    ALfloat listenerVel[] = {listenerVX / 1.0, listenerVY / 1.0, listenerVZ / 1.0};
    return play_audio(ctx, filename, sourcePos, sourceVel, listenerPos, listenerVel);
}
}


extern "C" DLL_EXPORT BOOL APIENTRY DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
    switch (fdwReason)
    {
        case DLL_PROCESS_ATTACH:
            // attach to process
            // return FALSE to fail DLL load
            break;

        case DLL_PROCESS_DETACH:
            // detach from process
            break;

        case DLL_THREAD_ATTACH:
            // attach to thread
            break;

        case DLL_THREAD_DETACH:
            // detach from thread
            break;
    }
    return TRUE; // succesful
}
