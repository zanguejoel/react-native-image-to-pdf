import { Text, View, StyleSheet, Button } from 'react-native';
import { createPdfFromImages } from 'react-native-image-to-pdf';

export default function App() {
  function pdf() {
    const imagePaths = ['/path/to/image1.jpg', '/path/to/image2.jpg'];
    const outputPath = '/tmp/output.pdf';

    createPdfFromImages(imagePaths, outputPath);
  }
  return (
    <View style={styles.container}>
      <Text>Result: pdf</Text>
      <Button title="Create PDF" onPress={pdf} />
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
