import {
  Text,
  View,
  StyleSheet,
  Button,
  Alert,
  ScrollView,
  Linking,
} from 'react-native';
import { useState } from 'react';
import { createPdfFromImages } from 'react-native-image-to-pdf';
import DocumentPicker from 'react-native-document-picker';
import RNFS from 'react-native-fs';

export default function App() {
  const [pdfPath, setPdfPath] = useState<string>('');
  const [isLoading, setIsLoading] = useState(false);

  const pickFile = async () => {
    try {
      setIsLoading(true);
      const res: any = await DocumentPicker.pick({
        type: [DocumentPicker.types.images],
      });

      const fileUri = res[0].uri;
      console.log('File URI:', fileUri);

      const imagePaths = [fileUri];
      const documentsPath = RNFS.DocumentDirectoryPath;
      const outputPath = `${documentsPath}/output.pdf`;
      const result = await createPdfFromImages(imagePaths, outputPath);
      setPdfPath(result);
      console.log('PDF created successfully:', result);
      Alert.alert('Success', `PDF created successfully`);
    } catch (err) {
      if (DocumentPicker.isCancel(err)) {
        console.log('User cancelled file picker');
      } else {
        console.error('Error picking file:', err);
        Alert.alert('Error', `Failed to create PDF: ${err}`);
      }
    } finally {
      setIsLoading(false);
    }
  };

  const openPdf = async () => {
    if (!pdfPath) {
      Alert.alert('No PDF', 'Please create a PDF first');
      return;
    }

    try {
      const canOpen = await Linking.canOpenURL(pdfPath);
      if (canOpen) {
        await Linking.openURL(pdfPath);
      } else {
        Alert.alert('Error', 'Cannot open PDF with available apps');
      }
    } catch (error) {
      console.error('Error opening PDF:', error);
      Alert.alert('Error', `Failed to open PDF: ${error}`);
    }
  };

  const clearPdf = () => {
    setPdfPath('');
  };

  return (
    <ScrollView style={styles.container}>
      <View style={styles.content}>
        <Text style={styles.title}>Image to PDF</Text>

        <Button
          title={isLoading ? 'Creating PDF...' : 'Select Image & Create PDF'}
          onPress={pickFile}
          disabled={isLoading}
        />

        {pdfPath && (
          <View style={styles.resultContainer}>
            <Text style={styles.successText}>✓ PDF Created</Text>
            <Text style={styles.pathText}>{pdfPath}</Text>
            <View style={styles.buttonGroup}>
              <View style={styles.button}>
                <Button title="Open PDF" onPress={openPdf} color="#2196F3" />
              </View>
              <View style={styles.button}>
                <Button
                  title="Create Another"
                  onPress={pickFile}
                  color="#4CAF50"
                />
              </View>
              <View style={styles.button}>
                <Button title="Clear" onPress={clearPdf} color="#FF9800" />
              </View>
            </View>
          </View>
        )}
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  content: {
    padding: 20,
    paddingTop: 40,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 20,
    textAlign: 'center',
    color: '#333',
  },
  resultContainer: {
    marginTop: 30,
    backgroundColor: '#fff',
    borderRadius: 8,
    padding: 15,
    borderLeftWidth: 4,
    borderLeftColor: '#4CAF50',
  },
  successText: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#4CAF50',
    marginBottom: 10,
  },
  pathText: {
    fontSize: 12,
    color: '#666',
    marginBottom: 15,
    fontFamily: 'Courier New',
    backgroundColor: '#f9f9f9',
    padding: 10,
    borderRadius: 4,
  },
  buttonGroup: {
    gap: 10,
  },
  button: {
    marginBottom: 8,
  },
});
