import processing.video.*;

Movie newMovie;
PImage prev;
PImage difference;
PImage reference;
int flag = 0;
PImage src;
PImage img;

void setup()
{
  size(320, 240);
  newMovie = new Movie(this, "Wildlife.wmv");
  newMovie.frameRate(2);
  newMovie.play();
}

void draw()
{  
  if(newMovie.available())
  { 
    
    if(prev != null) {
      prev.copy(newMovie, 0, 0, newMovie.width, newMovie.height, 0, 0, newMovie.width, newMovie.height);
      newMovie.read();
    }
    else {
      newMovie.read();
      prev = createImage(newMovie.width, newMovie.height, newMovie.format);
      difference = createImage(newMovie.width, newMovie.height, newMovie.format);
      prev.copy(newMovie, 0, 0, newMovie.width, newMovie.height, 0, 0, newMovie.width, newMovie.height);
      newMovie.read();
    }
    
    loadPixels();
    newMovie.filter(BLUR, 1.5);
    newMovie.loadPixels();
    prev.loadPixels();
    difference.loadPixels();
    
    for(int i=0; i<newMovie.width; i++)
    {
      for(int j=0; j<newMovie.height; j++)
      {
        int index = i + j*newMovie.width;
        
        color thisFrame = newMovie.pixels[index];
        color prevFrame = prev.pixels[index];
        
        float diff = dist(red(thisFrame), green(thisFrame), blue(thisFrame), red(prevFrame), green(prevFrame), blue(prevFrame));
        
        if(diff > 30)
          difference.pixels[index]=color(255);
        else
          difference.pixels[index]=color(0);
        pixels[index] = difference.pixels[index];
      }
    }
    
    if(flag == 30) {
      reference = createImage(difference.width, difference.height, difference.format);
      reference = difference;
      src = reference;
      updatePixels();
      save("reference.jpg");
    }
    else {
      updatePixels();
    }
    flag++;
 
   if(flag == 35) {
     img = difference;
     save("diff.jpg");
   }
 
 
  }
}

