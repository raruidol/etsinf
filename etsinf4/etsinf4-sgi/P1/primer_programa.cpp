#include <iostream>
#include<GL/freeglut.h>

#define PRAC1 "Primer programa en OpenGL"

void display()
{
	glClearColor(0, 0, 0.3, 1);
	glClear(GL_COLOR_BUFFER_BIT);

	// Crear la escena y manejar la camara

	glFlush();
}
void reshape(GLint w, GLint h)
{

}
void main(int argc, char** argv)
{
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
	glutInitWindowSize(500, 400);
	glutInitWindowPosition(50, 600);
	glutCreateWindow(PRAC1);
	// Registro de callbacks
	glutDisplayFunc(display);
	glutReshapeFunc(reshape);
	// Puesta en marcha del bucle de atencion a eventos
	glutMainLoop();
}