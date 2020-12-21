#!/usr/bin/env python2.7
"""
This will generate a random Dexed patch wav.

This code is adapted from [this
example](http://doc.gold.ac.uk/~lfedd001/renderman.html)
"""

# First, we set up the two objects which render and create synth
# parameters respectively from the classes 'RenderEngine' and
# 'PatchGenerator'. I am working on Linux and therefore VSTs are
# shared objects - .so files. At the end I print out the plugins
# parameters so it is easy to see which parameter does what at which
# index.

import librenderman as rm
import soundfile
import numpy as np

# Important settings. These are good general ones.
sampleRate = 44100
bufferSize = 512
fftSize = 512

# This will host a VST. It will render the features and audio we need.
engine = rm.RenderEngine(sampleRate, bufferSize, fftSize)

# Load the VST into the RenderEngine.
# We use Dexed 0.9.4 which is VST2. Later version are VST3. If
# you want VST3, consider dpm vst3render.
path = "/home/renderman/Dexed.so"
engine.load_plugin(path)

# Create a patch generator. We can initialise it to generate the correct
# patches for a given synth by passing it a RenderEngine which has
# loaded a instance of the synthesiser.
generator = rm.PatchGenerator(engine)

# We can also get a string of information about the
# available parameters.
print engine.get_plugin_parameters_description()

# Rendering Patches
# We can render a patch by getting one from the generator, and
# rendering it with the engine. The archetecture of the DX7 and
# therefore Dexed too, needs to have any carrier operator's parameter
# 'EG LEVEL 4' set to 0.0 and 'EG RATE 4' to 1.0 to prevent hanging
# notes, its intentional - not a bug! Because we are just making
# random presets, I have overriden all of them because it would be
# too verbose in this tutorial to write logic to only set the carriers
# used in the set algorithm (parameter 4 - see the above output!)
# Overriding all the operator's level and rate parameters however
# completely kills the envelope - you'll probably want to experiment
# with all of this (or try removing the overriden parameters) if you
# end up trying Dexed too :)

# Get a random patch and set it.
new_patch = generator.get_random_patch()
engine.set_patch(new_patch)

# We need to override some parameters to prevent hanging notes in
# Dexed. 
overriden_parameters = [(26, 1.),  (30, 0.),  (48, 1.),  (52, 0.), 
                        (70, 1.),  (74, 0.),  (92, 1.),  (96, 0.), 
                        (114, 1.), (118, 0.), (136, 1.), (140, 0.)]

# Loop through each tuple, unpack it and override the correct
# parameter with the correct value to prevent hanging notes.
for parameter in overriden_parameters:
    index, value = parameter
    engine.override_plugin_parameter(index, value)


# Settings to play a note and extract data from the synth.
midiNote = 40
midiVelocity = 127
noteLength = 4.0
renderLength = 5.0

# Render the data. 
engine.render_patch(midiNote, midiVelocity, noteLength, renderLength)

# Get the data. Note the audio is automattically made mono, no
# matter what channel size for ease of use.
audio = engine.get_audio_frames()
#mfccs = engine.get_mfcc_features()

# Normalize the audio by peak
audio = audio / np.max(np.abs(audio))

# Save the audio
soundfile.write("example.wav", audio, sampleRate)

# Get the patch and display it!
patch = engine.get_patch()

# The patch is just a list of tuples, one int for index
# and one float for the value. I've printed out the patch,
# note the overriden parameters are the correct ones!
for parameter in patch:
    # Unpack and print the parameter tuple.
    index, value = parameter
    print "Index: " + '{:3d}'.format(index) + " --- Value: " + str(value) 
