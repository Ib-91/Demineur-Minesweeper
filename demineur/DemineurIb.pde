/////////////////////////////////////////////////////
//
// Initialisation de la fenêtre graphique
//
int  cote; //20pixel=1bloc
int bandeau;
int colonnes;
int lignes;

int etat;
final int INIT=0;
final int STARTED=1;
final int OVER=2;


int etat_bloc;
final int BLOC=0;
final int EMPTY=1;
final int FLAG=2;

int start;
int time;

int mines=15; // mines restantes
boolean debut; //si le chrono debute

int[] [] paves;  //grilles des blocs 

boolean[][] bombes; //position des bombes dans la grille

int[][] nb_bombes;//nombre de bombes présentes dans les huit cases autour de la case

boolean premierClic = true;

void settings() {
  size(600,370); //1bloc =20 pixel 20*30=600     16*20=320+50(car 50pxl du bandeau)=370
  cote=20;
  bandeau=50;
  colonnes=30;
  lignes=16;
  etat=INIT;
  etat_bloc=FLAG;
}

//
// Initialisation du programme
//
void setup() {
  init();
}

//
// Initialisation du jeu
//
void init() {
  etat_bloc=BLOC;
  premierClic=true;
  paves = new int [lignes][colonnes]; //la grille des blocs initialisées à l'etat BLOC
  for (int i=0; i< lignes; i++){
    for (int j=0; j < colonnes ;j++){
      paves[i][j]=BLOC;
    }
}
  bombes = new boolean [lignes][colonnes]; //la grille des bombes initialisées à la valeurs false
}

void calculerNbBombes() {
  nb_bombes = new int[lignes][colonnes];
  for (int i = 0; i < lignes; i++) {
    for (int j = 0; j < colonnes; j++) {
      nb_bombes[i][j] = voisins(i, j);
    }
  }
}

void genererBombes(int safeLigne, int safeCol) {
  // remet tout à false
  for (int i = 0; i < lignes; i++) {
    for (int j = 0; j < colonnes; j++) {
      bombes[i][j] = false;
    }
  }

  int nbMinesPlacees = 0;
  while (nbMinesPlacees < mines) {
    int li = int(random(lignes));
    int co = int(random(colonnes));

    // on évite la case du premier clic
    if ((li == safeLigne && co == safeCol) || bombes[li][co]) {
      continue;
    }
    bombes[li][co] = true;
    nbMinesPlacees++;
  }
}

//
// boucle de rendu
// - met à jour le temps écoulé depuis le début de la résolution
// - appelle la fonction d'affichage
//
void draw() {
  display();
}
//
// calcule le nombre de bombes dans les 8 cases voisines
// (x, y) = coordonnées de la case
//
int voisins(int x, int y) {
  int nbVoisins=0;
  for(int i=x-1; i<=x+1; i++){
    for(int j=y-1; j<=y+1; j++){
      // Vérifier que les indices i et j sont valides
      if (i >= 0 && i < lignes && j >= 0 && j < colonnes) {
      if (bombes[i][j]==true){
         nbVoisins+=1;
       }
      }
}
  }
  return nbVoisins;
  }
//
// affiche un bloc
// (x, y) = coordonnées du bloc
// (w, h) = dimensions du bloc
//
void drawBloc(int x, int y, int w, int h) {
  
  int posx=cote*x;
  int posy=cote*y;
  pushMatrix();
  translate(posx,posy+bandeau);

  noStroke();
  fill(255, 255, 255);
  rect(0,0,w,h);
  
  //rectangle gris
  stroke(190, 190, 190);
  fill(190, 190, 190);
  rect(2,2,w-2,h-2); //rect(2,2,18,18)
  
  //gris foncé
  stroke(120, 120, 120);
  fill(120, 120, 120);
  
  line(0,19,19,19);
  line(19,19,19,0);
  line(1,18,18,18);
  line(18,18,18,1);
  
  popMatrix();

}

//
// affiche un drapeau dans la case
// (x, y) = coordonnées de la case
//
void drawFlag(int x, int y) {
  int posx=cote*x;
  int posy=cote*y;
  pushMatrix();
  translate(posx, posy+bandeau);
  //base du drapeau
  stroke(0);
  fill(0,0,0);
  rect(4,15,12,2);
  rect(6,13,8,2);
  line(10,4,10,12);
  //drapeau
  stroke(255,0,0);
  fill(255,0,0);
  triangle(9,4, 9,8, 5,6);
  popMatrix();
}

//
// affiche une bombe dans la case
// (x, y) = coordonnées de la case
//
void drawBomb(int x, int y) {
  pushMatrix();
  int posx=cote*x;
  int posy=cote*y;
  translate(posx, posy+bandeau);
  
  stroke(0);
  fill(0,0,0);
  ellipse(10,10,8,8);
  line(5,5,15,15);
  line(5,15,15,5);
  line(4,10,16,10);
  line(10,4,10,16);
  
  fill(255,255,255);
  ellipse(8,9,4,4);
  popMatrix();

}

//
// affiche dans la case le nombre de mines
//  présentes dans les 8 cases voisines
//
void drawNbBombesACote(int i, int j) {
  if ((bombes[i][j] == false) && (nb_bombes[i][j]!=0)){
    
    if(nb_bombes[i][j]==1) {
      fill(0,35,245);
    }
    else if(nb_bombes[i][j]==2){
      fill(55,125,35);
    }
    else if(nb_bombes[i][j]==3){
      fill(250,50,35);
    }
    else if(nb_bombes[i][j]==4){
      fill(120,25,120);
    }
    else if(nb_bombes[i][j]==5){
      fill(115,20,10);
    }
    else if(nb_bombes[i][j]==6){
      fill(55,125,125);
    }
    else if (nb_bombes[i][j]>6){
      fill(0);
    }
    text(nb_bombes[i][j],j*cote+5,i*cote+67);
  }
}


//
// affiche le nombre de mines restant à localiser
//
void drawScore() {
  PFont police;
  police=createFont("DSEG7Classic-Bold.ttf" ,32);
  textFont(police);
  
  fill(0);
  rect(5,5,80,40); //haut à gauche de la fênetre
  
  fill(90,10,10);
  text("888", 5,41);
  
  fill(255,0,0);
  
  if (mines<10){
    text("00" + mines, 5, 41);}
  else if (mines<100){
    text("0"+mines, 5, 41);}
}

//
// affiche le temps écoulé depuis le début de la résolution
//
void drawTime() {
PFont police;
  police=createFont("DSEG7Classic-Bold.ttf" ,32);
  textFont(police);
  
  fill(0);
  rect(width-85,5,80,40); //haut à droite de la fênetre
  
  fill(90,10,10);
  text("888", width-85,40);
  
  fill(255,0,0);
  //text(time, width-85, 35);
  
  if (etat==STARTED){
    if (debut==false){//si le chrono a pas debuter
      debut=true;
      start=millis(); //enregistre le temps au lancement de la résolution du jeu
    }
    time=(millis()-start)/1000; //milliseconde en seconde
    //debut du code - debut de la resolution du jeu
  }
  if( etat==INIT){
    time=0;
  }  
  
  if (time<10){
    text("0"+"0" + time, width-85, 40);}
    
  else if (time<100){
    text("0"+time, width-85, 40);}
    
  else if (time>=999){
    text("999", width-85, 40);}
}

//
// dessine un smiley content au centre du bandeau
//
void drawHappyFace() {
  strokeWeight(1);
  noStroke();
  
  //bloc du smiley
  fill(255, 255, 255);
  rect(280,5,40,40);
  stroke(0);
  
  //rectangle gris
  stroke(190, 190, 190);
  fill(190, 190, 190);
  rect(282,7,38,38);
  
  //gris foncé
  stroke(120, 120, 120);
  fill(120, 120, 120);
  
  line(280,45,320,45);
  line(320,5,320,45);
  line(280,44,319,44);
  line(319,6,319,44);
  
  //smiley
  strokeWeight(2);
  stroke(0);
  fill(255,255,0);
  
  //La tête
  ellipse(300,25,25,25);
  fill (0,0,0);
  //Les yeux
  ellipse(295,21,3,3);
  ellipse(305,21,3,3);
  //La bouche
  noFill();
  arc(300,30,10,5,radians(0),radians(180));
}

//
// dessine un smiley mécontent au centre du bandeau
//
void drawSadFace() {
  noStroke();
  
  //bloc du smiley
  fill(255, 255, 255);
  rect(280,5,40,40);
  stroke(0);
  
  //rectangle gris
  stroke(190, 190, 190);
  fill(190, 190, 190);
  rect(282,7,38,38);
  
  //gris foncé
  stroke(120, 120, 120);
  fill(120, 120, 120);
  
  line(280,45,320,45);
  line(320,5,320,45);
  line(280,44,319,44);
  line(319,6,319,44);
  
  //smiley
  stroke(0);
  strokeWeight(2);
  fill(255,255,0);
  
  //La tête
  ellipse(300,25,25,25);
  fill (0,0,0);
  //Oeil gauche
  line(293,19,297,23);
  line(297,19,293,23);
  //Oeil droit
  line(303,19,307,23);
  line(307,19,303,23);
  //La bouche
  noFill();
  arc(300,31,10,3,radians(-180),radians(0));
  strokeWeight(1);
}

//
// affiche le démineur
//
void display() {
  background(192,192,192);
  stroke(0);
  line(0,50,600,50);
  if ((etat==INIT) || (etat== STARTED)){
    drawHappyFace();
    
  }
  else{
    drawSadFace();
  }
    
    drawTime();
    drawScore();
    
    PFont police_nombre =  createFont("mine-sweeper.ttf", 14);
    textFont(police_nombre);
  for(int i=0; i<lignes; i++){
    for(int j=0; j<colonnes; j++){ //pave = la grille des blocs/enregistre l'etat de chacun des blocs
  
  if ((paves[i][j]==BLOC) || (paves[i][j]==FLAG)){
    drawBloc(j,i,cote,cote);
    }
  if (paves[i][j]==FLAG){
    drawFlag(j,i);
    }
  if ((paves[i][j]==EMPTY) && (nb_bombes[i][j]!=0)){
    drawNbBombesACote(i,j);
    }
    }
  }
  if (etat==OVER){
    displayBombs(1,1);
  }
}
//
// affiche le démineur quand on a perdu
// = on révèle l'emplacement des bombes
// et on affiche le smiley mécontent
//
void displayBombs(int x, int y) {
    for(int i=0; i<lignes;i++){
      for(int j=0; j<colonnes; j++){
        if (bombes[i][j]==true){
          drawBomb(j,i); // Affiche les bombes
        }
      }
    }
  }
//
// calcule les blocs qui doivent être découverts
// = les blocs vides autour si (x, y) est vide
//
void decouvre(int x, int y, int origineX, int origineY, int rayonMax) {

  // Vérifier que la case est dans la grille
  if (x < 0 || x >= lignes || y < 0 || y >= colonnes) {
    return;
  }

  // Vérifier la distance au point d'origine
  float d = dist(x, y, origineX, origineY);
  if (d > rayonMax) {
    return;
  }

  // Si déjà découverte ou drapeau
  if (paves[x][y] == EMPTY || paves[x][y] == FLAG) {
    return;
  }

  // Découvrir la case
  paves[x][y] = EMPTY;

  // Si la case contient un numéro, on s'arrête
  if (nb_bombes[x][y] != 0) {
    return;
  }

  // Explorer les voisins
  for (int i = x - 1; i <= x + 1; i++) {
    for (int j = y - 1; j <= y + 1; j++) {
      if (!(i == x && j == y)) {
        decouvre(i, j, origineX, origineY, rayonMax);
      }
    }
  }
}


//
// calcule les blocs qui doivent être découverts
// = les blocs vides autour de la case (x, y) portant un numéro, 
// dont on a localisé tous les blocs voisins
//
void decouvre2(int x, int y) {
}

//
// met à jour le nombre de drapeaux voisins 
// qui ont été localisés et marqués
//
void updateNbDrapeaux(int x, int y) {
}

//
// gère les interactions souris
//


void mouseClicked() {
  if ((5<mouseY) && (mouseY<45) && (280<mouseX) && (mouseX<320) && (etat==STARTED)){
 // coordonnée du bloc du smiley
      etat=INIT;
      init();
      debut=false; //pour réinitialiser le chrono
  }
  
  else if (etat==OVER){//perdu
    if ((5<mouseY) && (mouseY<45) && (280<mouseX) && (mouseX<320)) { 
      // coordonnée du bloc du smiley
      etat=INIT;
      init();
      debut=false; //réinitialiser le chrono
      }
  }
  //Calculer le n° de ligne de la case cliquée:
  int nligne = (mouseY-bandeau)/cote;
  //Calculer le n° de colonne de la case cliquée:
  int ncolonne = (mouseX/cote);
  
  //
  if (etat!=OVER){ //Si on a perdu on peut cliquer que sur les smiley (pour recommencer)
  if (mouseY>bandeau){
    if (mouseButton==37){
      if (premierClic){
        genererBombes(nligne,ncolonne);
        calculerNbBombes();
        premierClic = false;
        etat= STARTED;
      }
      if(bombes[nligne][ncolonne]==true){ //il y a une bombe 
        etat=OVER;
        debut=false;
      }else{
        decouvre(nligne, ncolonne, nligne, ncolonne, 10);
      }
    }
  }
  //
  if (mouseY>bandeau){
    if (mouseButton==39){
      if(paves[nligne][ncolonne]==BLOC){
        paves[nligne][ncolonne]=FLAG;
        mines-=1;
      }
  else if (paves[nligne][ncolonne]==FLAG){
    paves[nligne][ncolonne]=BLOC;
    mines+=1;
    }
  }
  }
  
  if (etat==STARTED){
    if ((mouseX>314 && mouseX<334 && mouseY>217 && mouseY<237)) { // coordonnée d'une bombe
      etat=OVER; 
    }
  }   
}
}
