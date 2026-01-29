package com.imagetopdf

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.util.Log
import androidx.core.content.FileProvider
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.module.annotations.ReactModule
import com.itextpdf.io.image.ImageDataFactory
import com.itextpdf.kernel.pdf.PdfDocument
import com.itextpdf.kernel.pdf.PdfWriter
import com.itextpdf.layout.Document
import com.itextpdf.layout.element.Image
import java.io.File
import java.io.FileOutputStream
import kotlin.math.min

@ReactModule(name = ImageToPdfModule.NAME)
class ImageToPdfModule(reactContext: ReactApplicationContext) :
  NativeImageToPdfSpec(reactContext) {

  override fun getName(): String {
    return NAME
  }

  // Example method
  override fun multiply(a: Double, b: Double): Double {
    return a * b
  }

  @ReactMethod
  override fun createPdfFromImages(imagePaths: java.util.ArrayList<String>, outputPath: String, promise: Promise) {
    try {
      Log.d(TAG, "Starting PDF creation with ${imagePaths.size} images")
      
      // Create output directory if needed
      val outputFile = File(outputPath)
      outputFile.parentFile?.mkdirs()
      
      // Use iTextPDF to create a proper PDF
      val pdfWriter = PdfWriter(outputFile)
      val pdfDocument = PdfDocument(pdfWriter)
      val document = Document(pdfDocument)
      
      var loadedImages = 0
      
      for (imagePath in imagePaths) {
        Log.d(TAG, "Processing image: $imagePath")
        
        try {
          val imageFile = getImageFile(imagePath)
          
          if (imageFile != null) {
            Log.d(TAG, "Image file path: ${imageFile.absolutePath}")
            Log.d(TAG, "Image file exists: ${imageFile.exists()}")
            Log.d(TAG, "Image file size: ${imageFile.length()} bytes")
            
            if (imageFile.exists()) {
              // Add image to PDF
              val imageData = ImageDataFactory.create(imageFile.absolutePath)
              val image = Image(imageData)
              
              // Scale image to fit A4 page (595x842 points)
              val pageWidth = 595f
              val pageHeight = 842f
              val maxWidth = pageWidth - 40  // 20pt margin on each side
              val maxHeight = pageHeight - 40
              
              Log.d(TAG, "Original image size: ${image.imageWidth} x ${image.imageHeight}")
              
              if (image.imageWidth > maxWidth || image.imageHeight > maxHeight) {
                val widthScale = maxWidth / image.imageWidth
                val heightScale = maxHeight / image.imageHeight
                val scale = min(widthScale, heightScale)
                image.scale(scale, scale)
                Log.d(TAG, "Scaled image with factor: $scale")
              }
              
              // Center the image
              image.setMarginLeft((pageWidth - image.imageWidth) / 2)
              image.setMarginTop(20f)
              
              document.add(image)
              loadedImages++
              Log.d(TAG, "Added image to PDF: $imagePath")
            } else {
              Log.e(TAG, "Image file does not exist: ${imageFile.absolutePath}")
            }
          } else {
            Log.e(TAG, "Failed to get image file for: $imagePath")
          }
        } catch (e: Exception) {
          Log.e(TAG, "Error processing image $imagePath: ${e.message}")
          e.printStackTrace()
        }
      }
      
      // Close the document
      document.close()
      
      Log.d(TAG, "PDF creation finished with $loadedImages image(s)")
      
      if (loadedImages > 0) {
        Log.d(TAG, "PDF created successfully at: $outputPath")
        promise.resolve(outputPath)
      } else {
        promise.reject("no_images", "No images could be loaded from the provided paths")
      }
      
    } catch (e: Exception) {
      Log.e(TAG, "Error creating PDF: ${e.message}")
      e.printStackTrace()
      promise.reject("pdf_error", "Failed to create PDF: ${e.message}")
    }
  }
  
  private fun getImageFile(imagePath: String): File? {
    return try {
      val uri = Uri.parse(imagePath)
      val file = when {
        imagePath.startsWith("file://") -> {
          File(uri.path!!)
        }
        imagePath.startsWith("content://") -> {
          // For content URIs, we need to copy the file to cache
          val inputStream = reactApplicationContext.contentResolver.openInputStream(uri)
          inputStream?.use { stream ->
            val cacheFile = File(reactApplicationContext.cacheDir, "temp_image_${System.currentTimeMillis()}.jpg")
            val outputStream = FileOutputStream(cacheFile)
            outputStream.use { output ->
              stream.copyTo(output)
            }
            cacheFile
          }
        }
        else -> {
          File(imagePath)
        }
      }
      file
    } catch (e: Exception) {
      Log.e(TAG, "Error getting image file from $imagePath: ${e.message}")
      null
    }
  }

  companion object {
    const val NAME = "ImageToPdf"
    private const val TAG = "ImageToPdfModule"
  }
}


