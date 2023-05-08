#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo "Installing Variety Wallpaper" > ~/.status.txt

######## Variety (wallpaper Changer) Custom Config Setup #######
sudo apt install -y variety

# Create the initial folder structure and dotfiles
mkdir -p ~/.config/variety/{Downloaded,Favirotes,Fetched,pluginconfig,plugins,scripts,wallpaper}
date +"%Y-%M-%d %H:%M:%S" > ~/.config/variety/.firstrun
variety --version | awk '{print $2}' > ~/.config/variety/.version
# Create the initial Config file
cat > ~/.config/variety/variety.conf << "EOF"

# change_on_start = <True or False>
change_on_start = False

# change_enabled = <True or False>
change_enabled = True

# change_interval = <interval in seconds - not less than 5>
change_interval = 600

# safe_mode = <True or False>
safe_mode = False

# download_folder = <some folder> - when not specified, the default is ~/.config/variety/Downloaded
download_folder = ~/.config/variety/Downloaded

# download_preference_ratio - if we have "unconsumed" download sources, we'll prefer to show a newly
# downloades image instead of an existing one in this percentage of the cases
download_preference_ratio = 0.9

# Determine if the download folder sould not exceed a certain size (in megabytes)
# quota_enabled = <True or False>
# quota_size = <size in MB, minimum 50>
quota_enabled = True
quota_size = 1000

# favorites_folder = <some folder> - when not specified, the default is ~/.config/variety/Favorites
favorites_folder = ~/.config/variety/Favorites

# Prefer Copy to Favorites or Move to Favorites operation (or both), depending on the folder of the current image
# favorites_operations = <A list of directories and the preferred operation (Copy, Move or Both) for each of them>
# The default is: Downloaded:Copy;Fetched:Move;Others:Copy
# Order is important - the first matching entry will determine what operation(s) to show in the menu for a specific file
# Special folder names you can use: Downloaded, Fetched and Others (same as "/" - use it as last entry to determine the default operation)
# Example1: Downloaded:Copy;Fetched:Move;/pics/RandomImages:Move;/pics/OrganizedAlbums:Copy;Others:Copy
# Example2: Others:Both - always show both Copy and Move to Favorites, no matter which image is shown
# Move to Favorites is only shown when the user has write permissions over the file, otherwise we fallback to Copy
favorites_operations = Downloaded:Copy;Fetched:Move;Others:Copy

# fetch_folder = <some folder> - when not specified, the default is ~/.config/variety/Fetched
fetched_folder = ~/.config/variety/Fetched

# Clipboard monitoring settings
# clipboard_enabled = <True or False>
# clipboard_use_whitelist = <will we use a hosts whitelist, or we'll fetch from everywhere - True or False>
# clipboard_hosts = <comma-separated whitelist of hosts for which clipboard fetching is enabled>
clipboard_enabled = False
clipboard_use_whitelist = True
clipboard_hosts = "wallhaven.cc,wallpapers.net,flickr.com,imgur.com,deviantart.com,interfacelift.com,vladstudio.com,imageshack.us,deviantart.net,imageshack.com"

# Icon settings
# icon = <Light, Dark, Current, 1, 2, 3, 4, None, or a full path to an image file>
icon = Light

# Prefer only images with this color:
# desired_color_enabled = <True or False>
# desired_color = <None or rgb like this: 100 150 200>
# DISCLAIMER: This feature is still experimental
desired_color_enabled = False
desired_color = 160 160 160

# Minimum size of images to use, as a percentage of the screen resolution
# min_size_enabled = <True or False>
# min_size = <Percentage>
min_size_enabled = False
min_size = 80

# Should we use only landscape-oriented images?
# use_landscape_enabled = <True or False>
use_landscape_enabled = True

# Prefer light or dark images
# lightness_enabled = <True or False>
# lightness_mode = <0 for Dark, 1 for Light>
lightness_enabled = True
lightness_mode = 0

# Use a filter by rating?
# min_rating_enabled = <True or False>
# min_rating = <1 | 2 | 3 | 4 | 5>
min_rating_enabled = False
min_rating = 4

# What parts of the initial wizard have we covered
smart_notice_shown = False
smart_register_shown = False
stats_notice_shown = False

# Are smart features enabled (i.e. data collection on Fav/Trash operations), also sync, and anonymous usage stats collection?
# smart_enabled = <True or False>
smart_enabled = False
sync_enabled = True
stats_enabled = True

# Folder to copy the wallpaper image to and make it world-readable. Provides LightDM support.
# copyto_enabled = <True or False>, default is False
# copyto_folder = <Default or Path to a custom folder>, the default is Default
# Default means to use the XDG Pictures folder when home folder is unencrypted and /usr/share/backgrounds when it is encrypted.
copyto_enabled = False
copyto_folder = Default

# Clock settings
# clock_enabled = <True or False>
# clock_font = <FontName Size>, default is "Sans 70"
# clock_date_font = <FontName Size>, default is "Sans 30"
clock_enabled = False
clock_font = Sans 70
clock_date_font = Sans 30

# clock_filter = <an ImageMagick filter, read below>
#
# The filter defines the ImageMagick command that Variety uses to render the clock on the wallpaper.
# First some scaling is applied to get the image down to the screen size - this ensures
# the final drawn clock won't be rescaled by the desktop wallpaper system.
# Easiest way to see what's happening is to run variety with -v, enable clock and see what ImageMagick
# commands Variety dumps in the log.
#
# The user may want to customize the following aspects:
# fill - color of "filling"
# stroke - color of outline
# strokewidth - width of outline
# gravity - in which corner to display the clock - SouthEast, NorthEast, SouthWest, NorthWest
# annotate - these must be in the form 0x0+[%HOFFSET+X]+[%VOFFSET+Y], where you can edit X and Y -
# distance from the screen corner defined by gravity. Write them in even if they are 0.
#
# The %HOFFSET and %VOFFSET parameters are there for Variety to replace in order to compensate for the
# diferent dimensions of every image and screen.
# The several %FONT parameters are there for Variety to replace with the font settings from the GUI.
#
# The texts can contain these symbols:
#
# %H - hours (24), %I - zero-padded hours (12), %l - hours (12), %p - am or pm, %M - minutes,
# %A - day of week (full), %a - day of week abbreviation, %B - month name, %b - month abbreviation, %d - day of month, %Y - year.
# The full list for these can be seen here: http://docs.python.org/library/datetime.html#strftime-strptime-behavior
# Have in mind that Variety will not update the clock more often than once every minute, so using seconds (%S) for example is pointless
#
# A tutorial on "annotating" with ImageMagick that you may use as a reference: http://www.imagemagick.org/Usage/annotating/
# You can get a very uniquely looking clock with some of the more advanced techniques (e.g. circle-shaped text, interesting colors and shading, etc....).

clock_filter = "-density 100 -font `fc-match -f '%{file[0]}' '%CLOCK_FONT_NAME'` -pointsize %CLOCK_FONT_SIZE -gravity SouthEast -fill '#00000044' -annotate 0x0+[%HOFFSET+58]+[%VOFFSET+108] '%H:%M' -fill white -annotate 0x0+[%HOFFSET+60]+[%VOFFSET+110] '%H:%M' -font `fc-match -f '%{file[0]}' '%DATE_FONT_NAME'` -pointsize %DATE_FONT_SIZE -fill '#00000044' -annotate 0x0+[%HOFFSET+58]+[%VOFFSET+58] '%A, %B %d' -fill white -annotate 0x0+[%HOFFSET+60]+[%VOFFSET+60] '%A, %B %d'"

# Quotes settings
# quotes_enabled = <True or False>
# quotes_font = <FontName Size>, default is "Sans 30"
# quotes_text_color = <r g b>, default is 255 255 255
# quotes_bg_color = <r g b>, default is 80 80 80
# quotes_bg_opacity = <0-100>, default is 55
# quotes_width = <0-100>, default is 70
# quotes_hpos = <0-100>, default is 100
# quotes_vpos = <0-100>, default is 40
# quotes_max_length = a positive integer, quotes above this length will not be displayed
# (as they often won't fit well on screen)
# quotes_text_shadow = <True or False>, default is False
# quotes_disabled_sources = <|-separated list of disabled quote plugin names>, default is "Urban Dictionary"
# quotes_tags = <comma-separated list of tags>, default is empty
# quotes_authors = <comma-separated list of authors>, default is empty
# quotes_change_enabled = <True or False>
# quotes_change_interval = <interval in seconds - not less than 10>, default is 300
quotes_enabled = False
quotes_font = Sans Bold Italic 12
quotes_text_color = 255 255 255
quotes_bg_color = 80 80 80
quotes_bg_opacity = 26
quotes_text_shadow = True
quotes_width = 41
quotes_hpos = 100
quotes_vpos = 94
quotes_max_length = 250
quotes_disabled_sources = ""
quotes_tags = ""
quotes_authors = ""
quotes_change_enabled = True
quotes_change_interval = 600
quotes_favorites_file = ~/.config/variety/favorite_quotes.txt
quotes_favorites_format = fortune

# Slideshow settings
slideshow_favorites_enabled = True
slideshow_sources_enabled = True
slideshow_downloads_enabled = False
slideshow_custom_enabled = False
slideshow_custom_folder = ~/Pictures
slideshow_sort_order = Random
slideshow_monitor = All
slideshow_mode = Fullscreen
slideshow_seconds = 6.0
slideshow_fade = 0.4
slideshow_zoom = 0.2
slideshow_pan = 0.05

# List of sources
# Each source is srcX = <enabled or not|source type - one of image, folder, flickr, wallhaven, etc.|location>
# location depends on type - path or url or search options, or just a name for unconfigurable sources
# Folders are included recursively
# BE CAREFUL: all keys below (src1, src2, etc.) MUST be different
[sources]
src1 = True|favorites|The Favorites folder
src2 = True|fetched|The Fetched folder
src3 = True|folder|/usr/share/backgrounds
src4 = True|flickr|user:www.flickr.com/photos/peter-levi/;user_id:93647178@N00;
src5 = True|apod|NASA's Astronomy Picture of the Day
src6 = True|bing|Bing Photo of the Day
src7 = True|earthview|Google Earth View Wallpapers
src8 = True|unsplash|High-resolution photos from Unsplash.com

# Image filters to apply randomly to every wallpaper (ImageMagick is used for this)
# Each filter is filterX = <enabled or not|filter name|arguments to pass to ImageMagick when calling convert>
# BE CAREFUL: all keys below (filter1, filter2, etc.) MUST be different
[filters]
filter1 = False|Keep original|
filter2 = False|Grayscale|-type Grayscale
filter3 = False|Heavy blur|-blur 120x40
filter4 = False|Soft blur|-blur 20x7
filter5 = False|Oil painting|-paint 8
filter6 = False|Pointilism|-spread 10 -noise 3
filter7 = False|Pixellate|-scale 3% -scale 3333%

EOF

  # Now create the .desktop file so that it autostarts at login:
  mkdir -p ~/.config/autostart
cat > ~/.config/autostart/variety.desktop << "EOF"
[Desktop Entry]
Name=Variety
Comment=Variety Wallpaper Changer
Categories=GNOME;GTK;Utility;
Exec=/usr/bin/variety --profile /home/vmadmin/.config/variety/
MimeType=text/uri-list;x-scheme-handler/variety;x-scheme-handler/vrty;
Icon=variety
Terminal=false
Type=Application
StartupNotify=false
Actions=Next;Previous;PauseResume;History;Preferences;
Keywords=Wallpaper;Changer;Change;Download;Downloader;Variety;
X-GNOME-Autostart-Delay=20
StartupWMClass=Variety
EOF