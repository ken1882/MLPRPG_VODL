#include "main.h"

#define NUM_BUFFERS 1
#define NUM_SOURCES 1
#define NUM_ENVIRONMENTS 1
extern "C"
{
ALfloat listenerOri[] = {0.0, 0.0, 1.0, 0.0, 1.0, 0.0};

ALuint  buffer[NUM_BUFFERS];
ALuint  source[NUM_SOURCES];
ALuint  environment[NUM_ENVIRONMENTS];

ALsizei fsize, freq;
ALenum  format;
ALvoid  *data;

/**-------------------------------------------------**
 * Struct that holds the RIFF data of the Wave file.
 * The RIFF data is the meta data information that holds,
 * the ID, size and format of the wave file
 **-------------------------------------------------**/
struct RIFF_Header {
    char chunkID[4];
    int chunkSize;//size not including chunkSize or chunkID
    char format[4];
};
/**-------------------------------------------------**
 * Struct to hold fmt subchunk data for WAVE files.
 **-------------------------------------------------**/
struct WAVE_Format {
    char subChunkID[4];
    int subChunkSize;
    short audioFormat;
    short numChannels;
    int sampleRate;
    int byteRate;
    short blockAlign;
    short bitsPerSample;
};
/**-------------------------------------------------**
 * Struct to hold the data of the wave file
 **-------------------------------------------------**/
struct WAVE_Data {
    char subChunkID[4]; //should contain the word data
    int subChunk2Size; //Stores the size of the data block
};
/**-------------------------------------------------**
 * Check whether error occurred
 **-------------------------------------------------**/
string CheckError(int op = -1, int _err = 0){
    int err;
    if(op == -1){
        err = alGetError(); // clear any error messages
    }
    else{
        err = _err;
    }
    if(err != AL_NO_ERROR){
        string info = "";
        if(err == AL_INVALID_NAME)
            info = "Error : Invalid Name";
        else if(err == AL_INVALID_ENUM)
            info = "Error : Invalid Enum";
        else if(err == AL_INVALID_VALUE)
            info = "Error : Invalid Value";
        else if(err == AL_INVALID_OPERATION)
            info = "Error : Invalid Operation";
        else if(err == AL_OUT_OF_MEMORY){
            info = "Error : Out of Memory";
        }
        return info;
    }
    return "";
}
/**-------------------------------------------------**
 * Load wave file function.
 **-------------------------------------------------**/
bool load_wavfile(const string filename, ALuint* buffer,
                  ALsizei* fsize, ALsizei* frequency, ALenum* format){

    FILE* soundfile = NULL;
    WAVE_Format wave_format;
    RIFF_Header riff_header;
    WAVE_Data wave_data;
    unsigned char* data = 0;

    soundfile = fopen(filename.c_str(), "rb");

    // Read in the first chunk into the struct
    fread(&riff_header, sizeof(RIFF_Header), 1, soundfile);

    //Read in the 2nd chunk for the wave info
    fread(&wave_format, sizeof(wave_format), 1, soundfile);

    //check for extra parameters;
    if(wave_format.subChunkSize > 16){
        fseek(soundfile, sizeof(short), SEEK_CUR);
    }

    //Read in the the last byte of data before the sound file
    fread(&wave_data, sizeof(WAVE_Data), 1, soundfile);

    //Allocate memory for data
    data = new unsigned char [wave_data.subChunk2Size];
    fread(data, wave_data.subChunk2Size, 1, soundfile);

    //Now we set the variables that we passed in with the
    //data from the structs
    *fsize     = wave_data.subChunk2Size;
    *frequency = wave_format.sampleRate;

    //The format is worked out by looking at the number of
    //channels and the bits per sample.
    if(wave_format.bitsPerSample == 8){
        *format = wave_format.numChannels == 1 ? AL_FORMAT_MONO8 : AL_FORMAT_STEREO8;
    }
    else if(wave_format.bitsPerSample == 16){
        *format = wave_format.numChannels == 1 ? AL_FORMAT_MONO16 : AL_FORMAT_STEREO16;
    }

    //create our openAL buffer and check for success
    alGenBuffers(1, buffer);
    alBufferData(*buffer, *format, (void*)data, *fsize, *frequency);

    //clean up and return true if successful
    fclose(soundfile);
    delete[] data;
    return true;
}
/**-------------------------------------------------**
 * Main process
 **-------------------------------------------------**/
string openal_init(string filename, ALfloat* sourcePos, ALfloat* sourceVel,
               ALfloat* listenerPos, ALfloat* listenerVel){
    alListenerfv(AL_POSITION, listenerPos);
    alListenerfv(AL_VELOCITY, listenerVel);
    alListenerfv(AL_ORIENTATION, listenerOri);

    // Generate buffers, or else no sound will happen!
    alGenSources(1, source);
    string re = CheckError();
    if(re != "")return re;

    // BGM test
    load_wavfile(filename, buffer, &fsize, &freq, &format);
    re = CheckError();
    if(re != "")return re;

    alSourcef(source[0], AL_PITCH, 1.0f);
    alSourcef(source[0], AL_GAIN, 1.0f);
    alSourcefv(source[0], AL_POSITION, sourcePos);
    alSourcefv(source[0], AL_VELOCITY, sourceVel);
    alSourcei(source[0], AL_BUFFER, buffer[0]);
    //thread Athread(alSourcePlay, source[0]);
    alSourcePlay(source[0]);
    return "";
}
/**-------------------------------------------------**
 * Play given audio
 **-------------------------------------------------**/
int play_audio(ALCcontext* ctx, string filename, ALfloat* sourcePos, ALfloat* sourceVel,
               ALfloat* listenerPos, ALfloat* listenerVel){

    //alcMakeContextCurrent(NULL);
    alcMakeContextCurrent(ctx);
    string re = openal_init(filename, sourcePos, sourceVel, listenerPos, listenerVel);
    return re == "" ? 0 : 0xff;
}
}
