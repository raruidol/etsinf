#define PROYECTO "Estrella 3D"
#include <iostream> // Biblioteca de entrada salida
#include <cmath> // Biblioteca matemática de C
#include <gl\freeglut.h> // Biblioteca grafica
static GLuint estrella; //Id de la estrella
float distx = 2;
float disty = 2;
float distz = 2.5;

void init()
// Funcion de inicializacion propia
{
	estrella = glGenLists(1); // Obtiene el identificador de la lista
	glNewList(estrella, GL_COMPILE); // Abre la lista
									 // Dibuja la estrella en la lista
	glBegin(GL_TRIANGLE_STRIP);
	glVertex3f(0.7 * -sin(0 * 2 * 3.1415926 / 3), 0.7 * cos(0 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(1 * -sin(0 * 2 * 3.1415926 / 3), 1 * cos(0 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(0.7 * -sin(1 * 2 * 3.1415926 / 3), 0.7 * cos(1 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(1 * -sin(1 * 2 * 3.1415926 / 3), 1 * cos(1 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(0.7 * -sin(2 * 2 * 3.1415926 / 3), 0.7 * cos(2 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(1 * -sin(2 * 2 * 3.1415926 / 3), 1 * cos(2 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(0.7 * -sin(0 * 2 * 3.1415926 / 3), 0.7 * cos(0 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(1 * -sin(0 * 2 * 3.1415926 / 3), 1 * cos(0 * 2 * 3.1415926 / 3), 0.0);
	glEnd();

	glBegin(GL_TRIANGLE_STRIP);
	glVertex3f(0.7 * sin(1 * 2 * 3.1415926 / 3), 0.7 * -cos(1 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(1 * sin(1 * 2 * 3.1415926 / 3), 1 * -cos(1 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(0.7 * sin(2 * 2 * 3.1415926 / 3), 0.7 * -cos(2 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(1 * sin(2 * 2 * 3.1415926 / 3), 1 * -cos(2 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(0.7 * sin(0 * 2 * 3.1415926 / 3), 0.7 * -cos(0 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(1 * sin(0 * 2 * 3.1415926 / 3), 1 * -cos(0 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(0.7 * sin(1 * 2 * 3.1415926 / 3), 0.7 * -cos(1 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(1 * sin(1 * 2 * 3.1415926 / 3), 1 * -cos(1 * 2 * 3.1415926 / 3), 0.0);
	glEnd();
	glEndList(); // Cierra la lista

	//Tener en cuenta la profundidad logica
	glEnable(GL_DEPTH_TEST);
}
void display()
// Funcion de atencion al dibujo
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glClearColor(1, 1, 1, 1);

	//Translate no afecta a la vista con estas 2 lineas de codigo
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	gluLookAt(distx, disty, distz, 0, 0, 0, 0, 1, 0);
	
	glPushMatrix();
	for (float i = 1; i <= 6; i=i+1) {	
		float mod = i / 10;
		glColor3f(1-mod,1-mod,0+mod);
		glRotatef(30,0,1,0);
		glCallList(estrella);
	}
	glPopMatrix();

	glColor3f(0, 0, 1);
	glutWireSphere(1.0, 20, 20);

	glFlush();
}
void reshape(GLint w, GLint h)
// Funcion de atencion al redimensionamiento
{
	//Marco dentro de area de dibujo
	glViewport(0, 0, w, h);
	float razon = (float)w / h;

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	float distbase = sqrt(distx*distx + distz*distz);
	float distrecta = sqrt(disty*disty + distbase*distbase);
	gluPerspective(2 *(asin(1/distrecta)*(180/3.1416)), razon, 1, 20);
}
void main(int argc, char** argv)
// Programa principal
{
	glutInit(&argc, argv); // Inicializacion de GLUT
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB | GLUT_DEPTH); // Alta de buffers a usar
	glutInitWindowSize(600, 600); // Tamanyo inicial de la ventana
	glutCreateWindow(PROYECTO); // Creacion de la ventana con su titulo
	init(); // Inicializacion propia. IMPORTANTE SITUAR AQUI
	std::cout << PROYECTO << " running" << std::endl; // Mensaje por consola
	glutDisplayFunc(display); // Alta de la funcion de atencion a display
	glutReshapeFunc(reshape); // Alta de la funcion de atencion a reshape
	glutMainLoop(); // Puesta en marcha del programa
}
