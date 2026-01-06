import 'package:flutter/material.dart';

class RingSizerPage extends StatefulWidget {
  const RingSizerPage({super.key});

  @override
  State<RingSizerPage> createState() => _RingSizerPageState();
}

class _RingSizerPageState extends State<RingSizerPage> {
  // Par défaut, on est en mode "Bague"
  bool isRing = true;

  // Valeurs initiales
  double diameter = 200.0; // Pour la bague (pixels)
  double wristWidth = 200.0; // Pour le bracelet (pixels)

  // Calibration approximative (1 px = 0.264 mm)
  double pixelsToMm = 0.264;

  @override
  Widget build(BuildContext context) {
    // Calculs dynamiques selon le mode
    double sizeInMm = (isRing ? diameter : wristWidth) * pixelsToMm;

    // Pour la bague : Circonférence = Diamètre * Pi
    // Pour le bracelet : On estime le tour de poignet (approximation ovale)
    String resultText;
    if (isRing) {
      String tailleFR = (sizeInMm * 3.14159).toStringAsFixed(0);
      resultText = "Taille Bague (FR) : $tailleFR";
    } else {
      // Pour un bracelet, on affiche souvent en CM
      // Estimation simple : largeur + 20% pour faire le tour
      double tourPoignetCm = (sizeInMm * 3.5) / 10;
      resultText = "Tour Poignet : ${tourPoignetCm.toStringAsFixed(1)} cm";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Outil de Mesure"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // --- 1. L'INTERRUPTEUR BAGUE / BRACELET ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("💍 Bague", style: TextStyle(fontWeight: isRing ? FontWeight.bold : FontWeight.normal)),
                Switch(
                  value: !isRing, // Si c'est faux, on est en mode bracelet
                  activeColor: Colors.purple,
                  inactiveThumbColor: Colors.amber,
                  inactiveTrackColor: Colors.amber[200],
                  onChanged: (val) {
                    setState(() {
                      isRing = !val; // Inverse le mode
                    });
                  },
                ),
                Text("Bracelet ⌚", style: TextStyle(fontWeight: !isRing ? FontWeight.bold : FontWeight.normal)),
              ],
            ),
          ),

          const Spacer(),

          // --- 2. LA FORME VISUELLE (Cercle ou Ovale) ---
          Center(
            child: Container(
              width: isRing ? diameter : wristWidth,
              height: isRing ? diameter : (wristWidth * 0.7), // Ovale pour le bracelet
              decoration: BoxDecoration(
                shape: isRing ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: isRing ? null : BorderRadius.circular(100), // Arrondi pour faire ovale
                color: (isRing ? Colors.amber : Colors.purple).withOpacity(0.3),
                border: Border.all(
                  color: isRing ? Colors.amber : Colors.purple,
                  width: 4.0,
                ),
              ),
              child: Center(
                child: Text(
                  isRing
                      ? "${sizeInMm.toStringAsFixed(1)} mm"
                      : "Largeur Poignet",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          const Spacer(),

          // --- 3. LE RÉSULTAT ---
          Text(
            resultText,
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isRing ? Colors.amber[800] : Colors.purple[800]
            ),
          ),

          const SizedBox(height: 20),

          // --- 4. LE SLIDER ---
          Container(
            color: Colors.grey[50],
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(isRing ? "Ajuster le cercle :" : "Ajuster la largeur du poignet :"),
                Slider(
                  value: isRing ? diameter : wristWidth,
                  min: 50.0,
                  max: 350.0,
                  activeColor: isRing ? Colors.amber : Colors.purple,
                  onChanged: (newValue) {
                    setState(() {
                      if (isRing) {
                        diameter = newValue;
                      } else {
                        wristWidth = newValue;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}