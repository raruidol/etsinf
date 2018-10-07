# -*- coding: utf-8 -*-

# COMPLETAR PARA LA ENTREGA DE ESTA PRÁCTICA:
# Fecha:
# Alumno(s):

from PIL import Image, ImageTk
import tkinter
import random
import numpy
import sys
import time
import math

def compute_gradient(grad,img,path):
    """
    img  is a 2-dimensional grayscale image in a list of list format
    grad is the output represented in the same way
    path is None during the first iteration and contains the previous seam path afterwards
    observe that the gradient is not computed for the first and last rows 
    so that you do not have to use these first and last rows
    """
    width, height = len(grad[0]), len(grad)

    # MODIFY this function in order make it possible the incremental
    # computation of the gradient

    # first and last rows compute a different, simpler, gradient



    if path == None:
        for y in (0, height-1): # just first and last rows
            for x in range(1, width-1): # first and last columns are excluded
                grad[y][x] = abs(img[y][x-1] - img[y][x+1])
    
    
        for y in range(1,height-1): # gradient for the rest of rows is based on Sobel operator
            for x in range(1, width-1): # first and last columns are excluded
                gx = -img[y-1][x-1]-2*img[y][x-1]-img[y+1][x-1]+img[y-1][x+1]+2*img[y][x+1]+img[y+1][x+1]
                gy =  img[y-1][x-1]+2*img[y-1][x]+img[y-1][x+1]-img[y+1][x-1]-2*img[y+1][x]-img[y+1][x+1]
                grad[y][x] = math.sqrt(gx*gx+gy*gy)
    else:
        for y in (0, height-1):
            for x in range(max(path[y]-2,1),min(path[y]+2,width-1)):
                grad[y][x] = abs(img[y][x-1]-img[y][x+1])
        for y in range(1,len(path)-1):
            for valor in range(0,4):
                izq = path[y]+valor-2
                if izq<2 or izq>width-2:
                    #si es los bordes no hacemos nada.
                    izq = 0
                    
                else:
                    gx = -img[y-1][izq-1]-2*img[y][izq-1]-img[y+1][izq-1]+img[y-1][izq+1]+2*img[y][izq+1]+img[y+1][izq+1]
                    gy =  img[y-1][izq-1]+2*img[y-1][izq]+img[y-1][izq+1]-img[y+1][izq-1]-2*img[y+1][izq]-img[y+1][izq+1]
                    grad[y][izq] = math.sqrt(gx*gx+gy*gy)




          
def paint_seam(height,seam_path,color_matrix,path_color=[0,0,0]):
    """
    You don't need to modify this function
    """
    for y in range(height):
        color_matrix[y][seam_path[y]] = path_color

def remove_seam(height,seam_path,color_matrix):
    """
    You don't need to modify this function
    """
    for y in range(height):
        color_matrix[y].pop(seam_path[y])

def dp_seam_carving(grad,mat):
    """
    dynamic programming version which finds just one path/seam and
    returns it

    first and last columns are never considered in this algorithm
    """
    width, height = len(grad[0]), len(grad)
    infty=1e99
    # first row deserves special treatment:
    mat[0][0]       = infty
    mat[0][width-1] = infty
    for x in range(1,width-1):
        mat[0][x] = grad[0][x]
    # the rest of rows
    for y in range(1,height):
        mat[y][0]       = infty
        mat[y][width-1] = infty
    for y in range(1,height):
        for x in range(1,width-1):
                mat[y][x] = grad[y][x]+min(mat[y-1][x-1],mat[y-1][x],mat[y-1][x+1])               
    min_val = infty
    min_point = 0
    for x in range(1,width-1):
        if min_val>mat[height-1][x]:
            min_val = mat[height-1][x]
            min_point = x
 


 #   retrieve the best path from min_point
    path = [min_point]
    # retrieve the complete path
    y = height - 1
    while y != 0:
        y -= 1
        if mat[y][min_point-1] <= mat[y][min_point] <= mat[y][min_point+1]:
            min_point -= 1
            path.append(min_point)
        elif mat[y][min_point] <= mat[y][min_point-1] <= mat[y][min_point+1]:
            path.append(min_point)
        else:
            min_point += 1
            path.append(min_point)
    path.reverse()
    return path

def matrix_to_color_image(color_matrix):
    """
    You don't need to modify this function
    """
    return Image.fromarray(numpy.array(color_matrix, dtype=numpy.uint8))
    
def save_matrix_as_color_image(color_matrix,filename):
    """
    You don't need to modify this function
    """
    img = matrix_to_color_image(color_matrix)
    img.save(filename)

######################################################################
#################       GRAPHICAL APPLICATION       ##################
######################################################################

class MyTkApp():
    """
    You don't need to modify this class
    """
    def __init__(self,
               color_img,
               removed_colums):

        self.root=tkinter.Tk()
        self.root.title("Seam Carving")
        self.color_img = color_img
        self.removed_colums = removed_colums
        width, height = color_img.size
        height = min(720, height)
        self.root.geometry('%dx%d' % (width, height+64))
        self.canvas = tkinter.Canvas(self.root.master,width=width,height=height)
        # Image
        imTk = ImageTk.PhotoImage(color_img)
        self.center_x = imTk.width()/2
        self.center_y = imTk.height()/2
        self.canvas_img = imTk
        self.canvas.pack()

        l = tkinter.Label(self.root)
        l.pack()
        self.b = tkinter.Button(self.root, text="Begin", command=self.runSeamCarving)
        self.b.pack()
        self.running = True
        self.root.mainloop()

    def showImg(self, im):
        "Updating image"
        imTk = ImageTk.PhotoImage(im)
        width, height = im.size
        self.canvas.delete(self.canvas_img)
        self.canvas_img = imTk
        self.canvas.create_image(self.center_x, self.center_y, image = self.canvas_img)
        self.canvas.update()

    def runSeamCarving(self):
      self.b.config(text="Carving...")
      t0 = time.time()

      color_img = self.color_img
      removed_colums = self.removed_colums
      width,height = color_img.size
      # convert the color image to a numpy array    
      color_numpy = numpy.array(color_img.getdata()).reshape(height, width,3) # 3 for RGB
      # convert the numpy array into a list of lists, we will use this
      # list of lists (a list of rows) as our data structure during the
      # computations:
      color_matrix = color_numpy.tolist()
      
      # make the same for the grayscale version of the image:
      grayscale_img = color_img.convert("F")
      grayscale_numpy = numpy.array(grayscale_img.getdata()).reshape(height,width)
      grayscale_matrix = grayscale_numpy.tolist()
      
      # let's construct the gradient matrix as a list of lists:
      gradient_matrix = [[0.0 for x in range(width)] for y in range(height)]
      # let's construct the dynamic programming matrix as a list of lists:
      infty = 1e99
      dp_matrix = [[infty for x in range(width)] for y in range(height)]
      
      self.showImg(color_img) # show image
      seam_path = None # is None only in the very first iteration
      for iteration in range(removed_colums):
        # compute the gradient
        compute_gradient(gradient_matrix,grayscale_matrix,seam_path)
        # call the DP algorithm, updating the seam_path:
        seam_path = dp_seam_carving(gradient_matrix,dp_matrix)
        paint_seam(height,seam_path,color_matrix)
        # paint and show the seam
        self.showImg(matrix_to_color_image(color_matrix))
        # remove the seam path from the color matrix:
        remove_seam(height,seam_path,color_matrix)
        # remove from the grayscale_matrix
        remove_seam(height,seam_path,grayscale_matrix)
        # remove from the gradient matrix
        remove_seam(height,seam_path,gradient_matrix)
        # decrement width
        width -= 1
        # paint and show the seam
        self.showImg(matrix_to_color_image(color_matrix))

      # finally, save the resulting image:
      output_file = "seam_carved_" + file_name
      save_matrix_as_color_image(color_matrix,output_file)
      t = time.time() - t0
      print('Final time:', t)
      self.b.config(text="Begin")

######################################################################
######################       MAIN PROGRAM       ######################
######################################################################
if __name__ == "__main__":
    """
    You don't need to modify the main function
    """
    if len(sys.argv) != 3:
        print('\n%s image_file {num_column|%%}\n'\
              % (sys.argv[0],))
        sys.exit()
        
    file_name = sys.argv[1]
    ncolumns  = sys.argv[2]

    # open image
    color_img = Image.open(file_name)
    width,height = color_img.size

    # it is required to open image before processing this parameter in
    # case columns are relative
    if ncolumns[-1] == '%':
        ncolumns = int(float(ncolumns[:-1]) * width / 100)
    else:
        ncolumns = int(ncolumns)
    # python allows us to write 3<ncolumns<width
    # but most other programming languages dont
    assert 3 < ncolumns and ncolumns < width
    # number of columns to be removed
    removed_colums = width - ncolumns

    # Tkinter
    app = MyTkApp(color_img,
                  removed_colums)
