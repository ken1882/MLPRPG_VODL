#ifndef __MAIN_H__
#define __MAIN_H__

#include <iostream>
#include <cstdio>
#include <thread>
#include <windows.h>
#include <AL/al.h>
#include <AL/alc.h>

using namespace std;

/*  To use this exported function of dll, include this header
 *  in your project.
 */

#ifdef BUILD_DLL
    #define DLL_EXPORT __declspec(dllexport)
#else
    #define DLL_EXPORT __declspec(dllimport)
#endif


#ifdef __cplusplus
extern "C"
{
#endif

void* DLL_EXPORT SetToThree(int* n);
void* DLL_EXPORT InitDevice(ALCdevice *dev);
void* DLL_EXPORT InitContext(ALCdevice* dev, ALCcontext* ctx);
int DLL_EXPORT DestroyDevice(ALCdevice* dev, ALCcontext* ctx);

int DLL_EXPORT PlayAudio(ALCcontext* ctx, LPSTR filename,
                          int sourceX, int sourceY, int sourceZ,
                          int listenerX, int listenerY, int listenerZ,
                          int sourceVX = 0, int sourceVY = 0, int sourceVZ = 0,
                          int listenerVX = 0, int listenerVY = 0, int listenerVZ = 0);

int play_audio(ALCcontext* ctx, string filename, ALfloat* sourcePos, ALfloat* sourceVel,
               ALfloat* listenerPos, ALfloat* listenerVel);
#ifdef __cplusplus
}
#endif

#endif // __MAIN_H__
