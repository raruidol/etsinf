#define PROYECTO "Transformaciones"
#include <iostream> // Biblioteca de entrada salida
#include <cmath> // Biblioteca matemática de C
#include <gl\freeglut.h> // Biblioteca grafica
static GLuint estrella; //Id de la estrella
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


	glClearColor(1, 1, 1, 1);
	glClear(GL_COLOR_BUFFER_BIT);
}
void display()
// Funcion de atencion al dibujo
{
	glClear(GL_COLOR_BUFFER_BIT); // Borra la pantalla
	glColor3f(0.0, 0.0, 0.8);


	//1er Cuadrante
	glPushMatrix();
	glTranslatef(-0.5, 0.5, 0);
	glScalef(0.5, 0.5, 0);
	glRotatef(15, 0, 0, 1);
	glCallList(estrella);
	glPushMatrix();
	glRotatef(-30, 0, 0, 1);
	glScalef(0.4, 0.4, 0.4);
	glCallList(estrella);
	glPopMatrix();
	glPopMatrix();

	//2o Cuadrante
	glPushMatrix();
	glTranslatef(0.5, 0.5, 0);
	glScalef(0.5, 0.5, 0);
	glRotatef(-15, 0, 0, 1);
	glCallList(estrella);
	glPushMatrix();
	glRotatef(30, 0, 0, 1);
	glScalef(0.4, 0.4, 0.4);
	glCallList(estrella);
	glPopMatrix();
	glPopMatrix();

	//3er Cuadrante
	glPushMatrix();
	glTranslatef(-0.5, -0.5, 0);
	glScalef(0.5, 0.5, 0);
	glRotatef(-15, 0, 0, 1);
	glCallList(estrella);
	glPushMatrix();
	glRotatef(30, 0, 0, 1);
	glScalef(0.4, 0.4, 0.4);
	glCallList(estrella);
	glPopMatrix();
	glPopMatrix();

	//4o Cuadrante
	glPushMatrix();
	glTranslatef(0.5, -0.5, 0);
	glScalef(0.5, 0.5, 0);
	glRotatef(15, 0, 0, 1);
	glCallList(estrella);
	glPushMatrix();
	glRotatef(-30, 0, 0, 1);
	glScalef(0.4, 0.4, 0.4);
	glCallList(estrella);
	glPopMatrix();
	glPopMatrix();

	glFlush(); // Finaliza el dibujo
}
void reshape(GLint w, GLint h)
// Funcion de atencion al redimensionamiento
{
}
void main(int argc, char** argv)
// Programa principal
{
	glutInit(&argc, argv); // Inicializacion de GLUT
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB); // Alta de buffers a usar
	glutInitWindowSize(400, 400); // Tamanyo inicial de la ventana
	glutCreateWindow(PROYECTO); // Creacion de la ventana con su titulo
	init(); // Inicializacion propia. IMPORTANTE SITUAR AQUI
	std::cout << PROYECTO << " running" << std::endl; // Mensaje por consola
	glutDisplayFunc(display); // Alta de la funcion de atencion a display
	glutReshapeFunc(reshape); // Alta de la funcion de atencion a reshape
	glutMainLoop(); // Puesta en marcha del programa
}
