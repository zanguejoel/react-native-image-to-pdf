import { Text, View, StyleSheet, Button } from 'react-native';
import { createPdfFromImages } from 'react-native-image-to-pdf';
import DocumentPicker from 'react-native-document-picker';
import RNFS from 'react-native-fs';

export default function App() {
  const pickFile = async () => {
    try {
      const res: any = await DocumentPicker.pick({
        type: [DocumentPicker.types.allFiles], // Allows any file type
      });

      // The result 'res' contains file details. For single file selection, you can access res[0]
      const fileUri = res[0].uri;
      console.log('File URI:', fileUri);

      // On Android, the picked file might be copied to the app's cache directory
      // for easier access using the 'copyTo' param during picking.

      // You can then use RNFS to read the file content
      const fileContent = await RNFS.readFile(fileUri, 'base64'); // Read as base64 or other encoding
      console.log('File Content (base64):', fileContent);

      const imagePaths = [fileUri];
      const outputPath = '/tmp/output.pdf';
      createPdfFromImages(imagePaths, outputPath);
    } catch (err) {
      if (DocumentPicker.isCancel(err)) {
        // User cancelled the file picker
        console.log('User cancelled file picker');
      } else {
        // Handle other errors
        console.error('Error picking file:', err);
      }
    }
  };
  return (
    <View style={styles.container}>
      <Text>Result: pdf</Text>
      <Button title="Create PDF" onPress={pickFile} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
