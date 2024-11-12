
Tile[] tiles = new Tile[100];

void setup(){
   size(1000, 1000);
   for (int i = 0; i < 100; i++){
     Tile tile = new Tile(100);
     tiles[i] = tile;
   }
   
   
   
   for (int y = 0; y < 10; y++){
     for(int x = 0; x < 10; x++){
        Tile tile = tiles[y * 10 + x];
        tile.ChangePositionAndUpdateIsCircle(x * tile.size, y * tile.size);
     }
     
   }
   
   
}

void draw(){
   for(Tile tile : tiles){
     if (dist(mouseX, mouseY, tile.posX, tile.posY) < 200){
       tile.draw(tile.posX + (int)random(-5, 5), tile.posY + (int)random(-5, 5));
     } else{
       tile.draw(tile.posX, tile.posY);
     }
   }
}
