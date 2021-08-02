include ../../Makefile.in

Lower_Parts=Lower_Left Lower_Middle Lower_Right \
						LowerMount_Front LowerMount_Rear
Lower_Parts_STL=$(addsuffix .stl, $(Lower_Parts))
Lower_Parts_Thumbnails=$(addsuffix _thumb.jpg, $(Lower_Parts))

README.html: $(Lower_Parts_Thumbnails)

all: README.html $(Lower_Parts_STL)
