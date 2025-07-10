import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import '../providers/user_provider.dart';
import '../services/payment_service.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final _userService = UserService();

  String? firstName;
  String? lastName;
  double? imc;
  String? _membresiaMensaje;
  Color _membresiaColor = Colors.orange;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId!;
    final user = await _userService.getUserDetail(userId);
    final paymentData = await PaymentService().fetchLatestMembershipPayment(userId);

    setState(() {
      firstName = user?['first_name'];
      lastName = user?['last_name'];
      imc = user?['imc'];

      if (paymentData != null) {
        final now = DateTime.now();
        final start = DateTime.parse(paymentData['start_date']);
        final end = DateTime.parse(paymentData['end_date']);

        if (now.isAfter(start) && now.isBefore(end)) {
          _membresiaMensaje = '✅ Cuenta con el Modo Plus';
          _membresiaColor = Colors.green;
        } else {
          _membresiaMensaje = '⚠️ Recuerda que solo tienes 7 días de prueba';
          _membresiaColor = Colors.orange;
        }
      } else {
        _membresiaMensaje = '⚠️ Recuerda que solo tienes 7 días de prueba';
        _membresiaColor = Colors.orange;
      }
    });
  }

  void _showLastPaymentDialog() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == null) return;

    final payment = await PaymentService().fetchLatestMembershipPayment(userId);

    showDialog(
      context: context,
      builder: (context) {
        if (payment == null) {
          return AlertDialog(
            title: const Text('Último Pago'),
            content: const Text('No se encontró información de pago.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          );
        }

        return AlertDialog(
          title: const Text('🧾 Último Pago'),
          content: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(),
            },
            children: [
              TableRow(children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text("Monto:", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text("\$${payment['amount']}"),
              ]),
              TableRow(children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text("Moneda:", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text(payment['currency']),
              ]),
              TableRow(children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text("Inicio:", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text(payment['start_date'].substring(0, 10)),
              ]),
              TableRow(children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text("Finaliza:", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text(payment['end_date'].substring(0, 10)),
              ]),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final goal = Provider.of<UserProvider>(context, listen: false).userGoal;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text("Perfil"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Ver último pago',
            onPressed: _showLastPaymentDialog,
          ),
        ],
        backgroundColor: const Color(0xFF226980),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            // Profile section
            const SizedBox(height: 25),
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                          'assets/profile.png',
                        ), // Cambiar por tu imagen local o de red
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: Color(0xFF226980),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${firstName ?? ''} ${lastName ?? ''}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // IMC Card mejorada
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.monitor_weight,
                            color: Color(0xFF226980),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Índice de Masa Corporal (IMC)",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.help_outline,
                              color: Color(0xFF226980),
                            ),
                            onPressed: () => showIMCModal(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            imc?.toStringAsFixed(1) ?? '...',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF226980),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            imc != null ? "Tu IMC está en un estado ${_estadoIMC(imc!)}" : '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF226980),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      const Text(
                        "Objetivo Actual",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(goal ?? 'Cargando...', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      const Text(
                        "Gráfica de progreso",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      const ProgressChart(),
                    ],
                  ),
                ),
              ),
            ),

            if (_membresiaMensaje != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _membresiaColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _membresiaColor),
                  ),
                  child: Text(
                    _membresiaMensaje!,
                    style: TextStyle(
                      color: _membresiaColor,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            const Spacer(),

            // Botón editar perfil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.pushNamed(context, 'edit_profile');
                    if (mounted) _loadUserData();
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    "Editar Perfil",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Color(0xFF226980),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, 'habit_questionnaire'),
                  icon: const Icon(Icons.assignment),
                  label: const Text(
                    'Cambiar H\u00e1bitos',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Color(0xFF226980),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, 'comment'),
                  icon: const Icon(Icons.comment),
                  label: const Text(
                    'Añadir Comentario',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Color(0xFF226980),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _estadoIMC(double imc) {
    if (imc < 18.5) return "bajo peso";
    if (imc < 25) return "saludable";
    if (imc < 30) return "sobrepeso";
    return "obesidad";
  }
}

// Al final de user_settings.dart:
class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key});

  static const Map<String, double> progressData = {
    // static const
    'Lun': 0.3, 'Mar': 0.5, 'Mié': 0.7, 'Jue': 0.9, 'Vie': 0.6,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Gráfica de progreso",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: CustomPaint(painter: const _BarChartPainter(progressData)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final day in progressData.keys)
              Text(day, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final Map<String, double> data;

  const _BarChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue[400]!;
    final barWidth = size.width / data.length * 0.6;
    final spacing = size.width / data.length * 0.4;

    var x = spacing / 2;
    for (final value in data.values) {
      final height = size.height * value;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - height, barWidth, height),
          const Radius.circular(4),
        ),
        paint,
      );
      x += barWidth + spacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void showIMCModal(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "IMC Info",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 48,
                      color: Color(0xFF226980),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "¿Qué es el IMC?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "El IMC (Índice de Masa Corporal) es un indicador que evalúa si tu peso es adecuado en relación a tu altura.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(3),
                      },
                      border: TableBorder.all(color: Colors.grey.shade300),
                      children: const [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.blueAccent),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "IMC",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Clasificación",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("< 18.5"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Bajo peso"),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("18.5 - 24.9"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Peso saludable"),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("25.0 - 29.9"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Sobrepeso"),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("30.0 o más"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Obesidad"),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.redAccent,
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        child: child,
      );
    },
  );
}


