﻿# Map Effects : User Guide v1.4
=begin
  Description :
    Insert after your other scripts in the script editor for better compatibility.
    This script allows to display effects on the map.
    The way it works is not very complicated, in fact it snap the current
    screen and display the screenshot in place of the actual map.
    The the effects are applied to the screenshot, some sort of post processing.
    To apply effects use one (or more) of the following functions in the
    events' script command.
    
  Log Change :
    1.4 :
      - small optimizations
      - reversed the behaviour of map_effects.back
      - fixed bug of map_effects.memorize
      - fixed bug of fluidity on some animations
    1.3 :
      - fixed display bug related to screen tone
      - fixed display bug related to shake screen
      - new function to memorize effects : map_effects.memorize
      - new function to restore memorized effects : map_effects.restore
      - new function to reset effects : map_effects.clear
      - added quick overview of functions below
    1.2 :
      - fixed bug on zoom and pixelize added by the last update
    1.1 :
      - better compatibilty with script Zeus Lights & Shadows
    
  Overview :
    - map_effects.memorize
    - map_effects.restore
    - map_effects.clear
    - map_effects.active = true or false
    - map_effects.refresh_rate = refresh rate of screenshots in number of fps.
    - map_effects.back = true or false
    - map_effects.mirror = true or false
    - map_effects.blend_type = 0 or 1 or 2
    - map_effects.set_zoom(zoom, duration, center_on_player)
    - map_effects.set_angle(angle, duration)
    - map_effects.set_wave(amp, length, speed, duration)
    - map_effects.set_origin(x, y)
    - map_effects.set_opacity(opacity, duration)
    - map_effects.set_color(red, green, blue, alpha, duration)
    - map_effects.set_tone(red, green, blue, gray, duration)
    - map_effects.set_hue(hue, duration)
    - map_effects.set_pixelize(pixel_size, duration)
    - map_effects.setup_blur(division, fade, animation, duration)
    - map_effects.set_gaussian_blur(length, duration)
    - map_effects.set_linear_blur(angle, length, duration)
    - map_effects.set_zoom_blur(zoom, duration)
    - map_effects.set_radial_blur(angle, duration)
    - map_effects.set_motion_blur(rate, duration)
    
  Properties, Fonctions :
    - map_effects.memorize
            Memorize all map effects settings.
            
    - map_effects.restore
            Restore all memorized map effects settings.
            
    - map_effects.clear
            Reset map effects settings except active and refresh_rate options.
            
    - map_effects.active = true or false
        Default value is true.
        Allow to activate or desactivate all effects at once.
        This script uses a certain amount of CPU, it can be interesting to let
        players with small configs disable effects as it's quite dispensable.
        
    - map_effects.refresh_rate = refresh rate of screenshots in number of fps.
        Default value is 30 => refresh a frame of two.
        The max value being 60.
        Because the effects consume CPU it may be useful to lower the refresh
        rate, especially as to some point it's not visible, well, it depends on
        the effects that we use too.
        Actually we could set the refresh_rate to 60 and the game would automatically
        drop frames when needed, but by lowering manually the refresh_rate we
        can obtain a better result.
        If we put 0, catches will no more be updated, the last capture will be
        used for effects, that way it's faster and it can be useful for more
        complicated effects, we can use it for transitions for example or some
        special scenes where nothing is moving.
        Modifying the refresh_rate is only related to this script (when effects
        are running) and won't alter anything else in the game.
        
    - map_effects.back = true or false
        Default value is false.
        Displays a picture of the map without any effects behind the effects pictures.
        To use in conjunction with map_effects.set_opacity so we can see it.
        If we use all this with map_effects.set_wave for example we can create
        a heat effect.
        
    - map_effects.mirror = true or false
        Default value is false.
        Displays map in mirror mode (aka horizontal flip), useless.
        
    - map_effects.blend_type = 0 or 1 or 2
        Default value is 0.
        Change the blending mode of effects picture.
        If 0 => Normal
        If 1 => Addition
        If 2 => Subtraction
        It's not very much by itself, but added to other color effects it can
        give cool stuff.
        
    - map_effects.set_zoom(zoom, duration, center_on_player)
            Zoom on map.
        zoom = a percent, preferably above 100.
            We can put values ​​below 100 but the image will just be reduced and
            centered, we will not see more of the map so it's not much use.
            Default value is 100.
        duration = transition time in number of frames.
            0 = no transition.
            We can omit this argument, which will put its value to 0.
            It will be the same thing all over so I won't repeat.
        center_on_player = true or false
            If true  => automatically centers the camera on the hero.
            If false => centers the camera in the middle of the screen.
            Therefore if the hero is in the middle of the screen it changes nothing.
            But basically you put false when scrolling camera and zooming at
            the same time.
            We can omit this argument, which will put its value to true.
        Examples :
            map_effects.set_zoom(200) # => zoom to 200% instant
            map_effects.set_zoom(200, 60) # => zoom to 200% on 60 frames
            map_effects.set_zoom(200, 60, false) # => idem but not auto centered
            
    - map_effects.set_angle(angle, duration)
            Rotate the map...
            In addition to being useless it's struggling (especially on vx ace),
            thus to be avoided in real time.
            However we can still use it to make transition effects having
            previously set refresh_rate to 0.
        angle = number of degrees.
            We can also put a negative number.
            Note that if you do a complete rotation (360 degrees) and want to
            redo it a second time it won't do anything, since you're already
            at 360° you'll have to rotate to 720° or reset angle to 0° before
            rotating to 360 again.
        Example :
            map_effects.set_angle(360, 60) # => do a barrel roll
          
    - map_effects.set_wave(amp, length, speed, duration)
            Makes the map waving.
        amp = amplitude (horizontal) of the wave in number of pixels.
            It must be a number greater than 0.
        length = length (vertical) of the wave in number of pixels.
            Default value is 180.
        speed = speed of the wave.
            Default value is 360.
        Example :
            map_effects.set_wave(4, 180, 360, 60)
            
    - map_effects.set_origin(x, y)
            Change the origin, mainly for the blur effects of zoom and radial.
            It is also effective for zooming and rotating the map, but in these
            cases it is better to leave in the middle.
            It does nothing if used without one these effects.
        x = x coordinate of center of the image as a percentage.
            0 = leftmost.
            100 = rightmost.
            Default value is 50.
        y = y coordinate of center of the image as a percentage.
            0 = topmost.
            100 = bottommost.
            Default value is 50.
        Example :
            map_effects.set_origin(100, 0) # Origin at top right corner
            
    - map_effects.set_opacity(opacity, duration)
            Change the opacity of the effects images, which means that it's
            useless without effects, to use with map_effects.back
            if we want to have something appear behind.
        opacity = percentage between 0 and 100.
            Default value is 100.
        Example :
            map_effects.set_opacity(75, 60)
            
    - map_effects.set_color(red, green, blue, alpha, duration)
            Colorise / Applies a color on the map.
        red, green, blue = numbers between 0 and 255.
            These are the components of the color.
        alpha = number between 0 and 255.
            This is the transparency of the color.
            Set to 0 to disable this effect.
        Example :
            map_effects.set_color(255, 0, 0, 128, 60) # => red map
            
    - map_effects.set_tone(red, green, blue, gray, duration)
            Change the tone of the map, it's like the screen command but for
            the map only.
            You may say "it's useless", yes and no, alone it is useless,
            better use the command to change the screen tone,
            but combined with other effects it can give new things.
        red, green, blue = numbers between -255 and 255.
            Same thing as in the command to the change the screen tone.
        gray = number between 0 and 255.
            This is the saturation, as in the command blablabla.
        Example :
            map_effects.set_color(0, 0, 0, 255, 60) # => map en noir et blanc
            
    - map_effects.set_hue(hue, duration)
            Change the hue of the map, it's very much struggling so it's not
            really usable but I had implemented it and as I don't like to work
            for nothing I left it.
        hue = a number.
            It is an angle to be more precise, so if you put 360 it will make
            a complete rotation of the hue.
        Example :
            map_effects.set_hue(180, 60)
            
    - map_effects.set_pixelize(pixel_size, duration)
            Pixelise screen, ok it's not super useful but can be used to make
            transitions like old school games.
            This is not a zoom.
        pixel_size = multiplier percentage of the pixel size.
            It must be greater than 100.
        Example :
            map_effects.set_pixelize(4000, 60) # => puke
        
    - map_effects.setup_blur(division, fade, animation, duration)
            Sets variables used by the various blur effects.
        division = number between 1 and 16.
            Default value is 4.
            This is the number of images used for the various blur effects.
            The more there are and the more it's nice and the more it uses CPU.
            For the Gaussian blur it is preferable to use a multiple of 4.
        fade = fade factor of the various blur images.
            Default value is 0, which means that the opacity of images is
            constant.
            For the Gaussian blur it's better to leave this value to 0.
            For others it can be modified depending on the effect you.
            The higher the value the faster the opacity fades out,
            we can also put a value bellow 0 to have a fade in effect.
            It is recommended to put a value of 100 for the zoom blur.
        animation = animation speed of blurs.
            Default value is 0 = no animation.
            We can put a negative value to change the direction of the animation.
            If you want to animate a blur it is best to also fade to 100,
            otherwise it's not pretty.
            Animation doesn't work with Gaussian blur nor motion blur.
        Example :
            map_effects.setup_blur(8, 100, 1)
            map_effects.set_linear_blur(0, 50, 60)
            
    - map_effects.set_gaussian_blur(length, duration)
            Applies a blur by superimposing the image of the map several times
            with a small offset, the number of overlay image being defined
            beforehand by blur_division, and for this one it's better to have a
            multiple of 4.
        length = the offset length, an integer.
            Default value is 0 = effect disabled.
            Better put small numbers, 1 is good for example.
            If the offset is too large it looks more like a drunk effect than
            a blur.
        Example :
            map_effects.set_gaussian_blur(10, 60)
            
    - map_effects.set_linear_blur(angle, length, duration)
            Linear blur in one direction.
        angle = direction of blur in degrees.
            0 = right
            90 = top
            etc...
        length = expanse of the blur in number of pixels.
            Default value is 0 = effect disabled.
        Example :
            map_effects.set_linear_blur(0, 20, 60)
            
    - map_effects.set_zoom_blur(zoom, duration)
            It is a zoom blur, ok?
        zoom = expanse of blur in zoom percentage.
            Default value is 100 = effect disabled.
            Min value is 0.
        Example :
            map_effects.set_zoom_blur(200, 60)
            
    - map_effects.set_radial_blur(angle, duration)
            This effect is unfortunately quite struggling, and overload
            increases exponentially with the number of blur images (division).
            Used together with zoom blur it gives a beautiful spiral effect but
            at 0 FPS.
        angle = expanse of blur in number of degrees.
            Default value is 0 = effect disabled.
        Example :
            map_effects.set_radial_blur(10, 60)
            
    - map_effects.set_motion_blur(rate, duration)
            It is a motion blour, yay.
        rate = latency of the effect in number of frames.
            Default value is 0 = effect disabled.
        Example :
            map_effects.set_motion_blur(1)
=end