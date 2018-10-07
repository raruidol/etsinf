#define PROYECTO "Reloj analogico"
#include <iostream> // Biblioteca de entrada salida
#include <cmath> // Biblioteca matemática de C
#include <gl\freeglut.h> // Biblioteca grafica
#include <ctime> 

#define tasaFPS 60
static GLuint reloj;
static float alfa = 0;
static float discrsec = 0, discrmin = 0, discranglesec = 0, discranglemin = 0;
float distx = 0;
float disty = 0;
float distz = 2;
time_t h, m, s;

void init()
// Funcion de inicializacion propia
{
	reloj = glGenLists(1);			// Id de la lista
	float radio = 1;

	time_t t = time(NULL);
	//printf("%d", t);
	h = (t / 3600) % 24;
	m = (t / 60) % 60;
	s = t % 60;
	printf("%d", h);
	printf("%d", m);
	printf("%d", s);


	// Crear la lista
	glNewList(reloj, GL_COMPILE);
	//glPolygonMode(GL_FRONT, GL_LINE);
	glColor3f(1.0, 1.0, 1.0);
	glBegin(GL_LINES);
	glVertex3f(1 * cos(0 * 2 * 3.1415926 / 12), 1 * sin(0 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(0.9 * cos(0 * 2 * 3.1415926 / 12), 0.9 * sin(0 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(1 * 2 * 3.1415926 / 12), 1 * sin(1 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(0.9 * cos(1 * 2 * 3.1415926 / 12), 0.9 * sin(1 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(2 * 2 * 3.1415926 / 12), 1 * sin(2 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(0.9 * cos(2 * 2 * 3.1415926 / 12), 0.9 * sin(2 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(3 * 2 * 3.1415926 / 12), 1 * sin(3 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(0.9 * cos(3 * 2 * 3.1415926 / 12), 0.9 * sin(3 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(4 * 2 * 3.1415926 / 12), 1 * sin(4 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(0.9 * cos(4 * 2 * 3.1415926 / 12), 0.9 * sin(4 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(5 * 2 * 3.1415926 / 12), 1 * sin(5 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(0.9 * cos(5 * 2 * 3.1415926 / 12), 0.9 * sin(5 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(6 * 2 * 3.1415926 / 12), 1 * sin(6 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(0.9 * cos(6 * 2 * 3.1415926 / 12), 0.9 * sin(6 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(7 * 2 * 3.1415926 / 12), 1 * sin(7 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(0.9 * cos(7 * 2 * 3.1415926 / 12), 0.9 * sin(7 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(8 * 2 * 3.1415926 / 12), 1 * sin(8 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(0.9 * cos(8 * 2 * 3.1415926 / 12), 0.9 * sin(8 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(9 * 2 * 3.1415926 / 12), 1 * sin(9 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(0.9 * cos(9 * 2 * 3.1415926 / 12), 0.9 * sin(9 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(10 * 2 * 3.1415926 / 12), 1 * sin(10 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(0.9 * cos(10 * 2 * 3.1415926 / 12), 0.9 * sin(10 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(11 * 2 * 3.1415926 / 12), 1 * sin(11 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(0.9 * cos(11 * 2 * 3.1415926 / 12), 0.9 * sin(11 * 2 * 3.1415926 / 12), 0.0);
	glEnd();
	glColor3f(0.0, 0.0, 0.0);
	glBegin(GL_POLYGON);
	glVertex3f(1 * cos(0 * 2 * 3.1415926 / 12), 1 * sin(0 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(1 * 2 * 3.1415926 / 12), 1 * sin(1 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(2 * 2 * 3.1415926 / 12), 1 * sin(2 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(3 * 2 * 3.1415926 / 12), 1 * sin(3 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(4 * 2 * 3.1415926 / 12), 1 * sin(4 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(5 * 2 * 3.1415926 / 12), 1 * sin(5 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(6 * 2 * 3.1415926 / 12), 1 * sin(6 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(7 * 2 * 3.1415926 / 12), 1 * sin(7 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(8 * 2 * 3.1415926 / 12), 1 * sin(8 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(9 * 2 * 3.1415926 / 12), 1 * sin(9 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(10 * 2 * 3.1415926 / 12), 1 * sin(10 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1 * cos(11 * 2 * 3.1415926 / 12), 1 * sin(11 * 2 * 3.1415926 / 12), 0.0);
	glEnd();
	glPushMatrix();
	glLineWidth(2);

	glColor3f(0.0, 0.0, 0.0);
	glutSolidSphere(0.03, 200, 200);
	glPopMatrix();
	glEndList();


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

	//glutWireSphere(1,20,20);


	glPushMatrix();
	glColor3f(1.0, 0.3, 0.5);
	glTranslatef(0, 0.5, 0);
	glRotatef(discranglemin*2 , 0, 0, -1);
	glScalef(0.5, 0.5, 0.5);
	glBegin(GL_POLYGON);
	glVertex3f(0.3 * cos(0 * 2 * 3.1415926 / 3), 0.3 * sin(0 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(0.3 * cos(1 * 2 * 3.1415926 / 3), 0.3 * sin(1 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(0.3 * cos(2 * 2 * 3.1415926 / 3), 0.3 * sin(2 * 2 * 3.1415926 / 3), 0.0);
	glEnd();
	glPopMatrix();

	glPushMatrix();
	glColor3f(1.0, 0.3, 0.5);
	glTranslatef(0, -0.5, 0);
	glRotatef(discranglemin*2, 0, 0, -1);
	glScalef(-0.5, -0.5, -0.5);
	glBegin(GL_POLYGON);
	glVertex3f(0.3 * cos(0 * 2 * 3.1415926 / 3), 0.3 * sin(0 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(0.3 * cos(1 * 2 * 3.1415926 / 3), 0.3 * sin(1 * 2 * 3.1415926 / 3), 0.0);
	glVertex3f(0.3 * cos(2 * 2 * 3.1415926 / 3), 0.3 * sin(2 * 2 * 3.1415926 / 3), 0.0);
	glEnd();
	glPopMatrix();

	glPushMatrix();
	glColor3f(1.0, 0.0, 0.5);
	glTranslatef(0.3, 0.2, 0);
	glRotatef(alfa / 2, 0, 0, 1);
	glScalef(0.5, 0.5, 0.5);
	glBegin(GL_POLYGON);
	glVertex3f(0.3 * cos(0 * 2 * 3.1415926 / 8), 0.3 * sin(0 * 2 * 3.1415926 / 8), 0.0);
	glVertex3f(0.3 * cos(1 * 2 * 3.1415926 / 8), 0.3 * sin(1 * 2 * 3.1415926 / 8), 0.0);
	glVertex3f(0.3 * cos(2 * 2 * 3.1415926 / 8), 0.3 * sin(2 * 2 * 3.1415926 / 8), 0.0);
	glVertex3f(0.3 * cos(3 * 2 * 3.1415926 / 8), 0.3 * sin(3 * 2 * 3.1415926 / 8), 0.0);
	glVertex3f(0.3 * cos(4 * 2 * 3.1415926 / 8), 0.3 * sin(4 * 2 * 3.1415926 / 8), 0.0);
	glVertex3f(0.3 * cos(5 * 2 * 3.1415926 / 8), 0.3 * sin(5 * 2 * 3.1415926 / 8), 0.0);
	glVertex3f(0.3 * cos(6 * 2 * 3.1415926 / 8), 0.3 * sin(6 * 2 * 3.1415926 / 8), 0.0);
	glVertex3f(0.3 * cos(7 * 2 * 3.1415926 / 8), 0.3 * sin(7 * 2 * 3.1415926 / 8), 0.0);
	glEnd();
	glPopMatrix();

	glPushMatrix();
	glColor3f(0.0, 1.0, 1.0);
	glRotatef(alfa / 4, 0, 0, -1);
	glBegin(GL_POLYGON);
	glVertex3f(0.3 * cos(0 * 2 * 3.1415926 / 8), 0.3 * sin(0 * 2 * 3.1415926 / 8), 0.0);
	glVertex3f(0.3 * cos(1 * 2 * 3.1415926 / 8), 0.3 * sin(1 * 2 * 3.1415926 / 8), 0.0);
	glVertex3f(0.3 * cos(2 * 2 * 3.1415926 / 8), 0.3 * sin(2 * 2 * 3.1415926 / 8), 0.0);
	glVertex3f(0.3 * cos(3 * 2 * 3.1415926 / 8), 0.3 * sin(3 * 2 * 3.1415926 / 8), 0.0);
	glVertex3f(0.3 * cos(4 * 2 * 3.1415926 / 8), 0.3 * sin(4 * 2 * 3.1415926 / 8), 0.0);
	glVertex3f(0.3 * cos(5 * 2 * 3.1415926 / 8), 0.3 * sin(5 * 2 * 3.1415926 / 8), 0.0);
	glVertex3f(0.3 * cos(6 * 2 * 3.1415926 / 8), 0.3 * sin(6 * 2 * 3.1415926 / 8), 0.0);
	glVertex3f(0.3 * cos(7 * 2 * 3.1415926 / 8), 0.3 * sin(7 * 2 * 3.1415926 / 8), 0.0);
	glEnd();
	glPopMatrix();

	

	glCallList(reloj);

	glPushMatrix();
	glColor3f(0.5, 0.0, 1.0);
	glRotatef(alfa / 8, 0, 0, 1);
	glBegin(GL_POLYGON);
	glVertex3f(1.0 * cos(0 * 2 * 3.1415926 / 12), 1.0 * sin(0 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1.0 * cos(1 * 2 * 3.1415926 / 12), 1.0 * sin(1 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1.0 * cos(2 * 2 * 3.1415926 / 12), 1.0 * sin(2 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1.0 * cos(3 * 2 * 3.1415926 / 12), 1.0 * sin(3 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1.0 * cos(4 * 2 * 3.1415926 / 12), 1.0 * sin(4 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1.0 * cos(5 * 2 * 3.1415926 / 12), 1.0 * sin(5 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1.0 * cos(6 * 2 * 3.1415926 / 12), 1.0 * sin(6 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1.0 * cos(7 * 2 * 3.1415926 / 12), 1.0 * sin(7 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1.0 * cos(8 * 2 * 3.1415926 / 12), 1.0 * sin(8 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1.0 * cos(9 * 2 * 3.1415926 / 12), 1.0 * sin(9 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1.0 * cos(10 * 2 * 3.1415926 / 12), 1.0 * sin(10 * 2 * 3.1415926 / 12), 0.0);
	glVertex3f(1.0 * cos(11 * 2 * 3.1415926 / 12), 1.0 * sin(11 * 2 * 3.1415926 / 12), 0.0);
	glEnd();
	glPopMatrix();

	


	//Varilla de horas
	glPushMatrix();
	glColor3f(1.0, 0.2, 0.2);
	glRotatef(alfa / 86400, 0, 0, -1);
	glRotatef((30 * (h + 1)) + ((6 * m * 30) / 360) - 90, 0, 0, -1);
	glTranslatef(0.25, 0, 0);
	glScalef(0.7, 0.03, 0.03);
	glutSolidCube(1);
	glPopMatrix();

	//Varilla de minutos
	glPushMatrix();
	glColor3f(1.0, 1.0, 0.0);
	glRotatef(alfa / 3600, 0, 0, -1);
	glRotatef((6 * m) + ((6 * s * 6) / 360) - 90, 0, 0, -1);
	glTranslatef(0.4, 0, 0);
	glScalef(1, 0.02, 0.02);
	glutSolidCube(1);
	glPopMatrix();

	//Varilla de segundos
	glPushMatrix();
	glColor3f(0.0, 0.0, 1.0);
	glRotatef(discranglesec*24 / 60, 0, 0, -1);
	glRotatef((6 * s) - 90, 0, 0, -1);
	glTranslatef(0.4, 0, 0);
	glScalef(1, 0.01, 0.01);
	glutSolidCube(1);
	glPopMatrix();


	glutSwapBuffers();
}

void onIdle()
// Funcion de atencion al evento idle
{

	// Animacion coherente con el tiempo transcurrido
	static const float omega = 1;	// vueltas por segundo

									// Incialmente la hora de arranque
	static int antes = glutGet(GLUT_ELAPSED_TIME);

	// Hora actual
	int ahora = glutGet(GLUT_ELAPSED_TIME);

	// Tiempo transcurrido
	float tiempo_transcurrido = (ahora - antes) / 1000.0f;

	alfa += omega * 360 * tiempo_transcurrido;
	antes = ahora;

	if ((int)(alfa / (360)) > discrsec) {
		discrsec = (int)alfa / (360);
		discranglesec = discrsec * 15;
	}
	
	if ((int)(alfa / (360*60)) > discrmin) {
		discrmin = (int)alfa / (360*60);
		discranglemin = discrmin * 15;
	}

	glutPostRedisplay();
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
	gluPerspective(2 * (asin(1 / distrecta)*(180 / 3.1416)), razon, 1, 20);
}
void main(int argc, char** argv)
// Programa principal
{
	glutInit(&argc, argv); // Inicializacion de GLUT
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH); // Alta de buffers a usar
	glutInitWindowSize(500, 500); // Tamanyo inicial de la ventana
	glutCreateWindow(PROYECTO); // Creacion de la ventana con su titulo
	init(); // Inicializacion propia. IMPORTANTE SITUAR AQUI
	std::cout << PROYECTO << " running" << std::endl; // Mensaje por consola

	glutDisplayFunc(display); // Alta de la funcion de atencion a display
	glutReshapeFunc(reshape); // Alta de la funcion de atencion a reshape

	glutIdleFunc(onIdle);

	glutMainLoop(); // Puesta en marcha del programa
}
