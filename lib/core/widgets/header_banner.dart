import 'package:flutter/material.dart';

class HeaderBanner extends StatelessWidget {

  final String title;

  final String subtitle;

  final String description;

  const HeaderBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(28),

        gradient: const LinearGradient(

          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: [

            Color(0xff2563EB),

            Color(0xff3B82F6),

          ],
        ),
      ),

      child: Row(

        children: [

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  style: const TextStyle(

                    color: Colors.white70,

                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 8),

                Text(

                  subtitle,

                  style: const TextStyle(

                    color: Colors.white,

                    fontWeight: FontWeight.bold,

                    fontSize: 28,
                  ),
                ),

                const SizedBox(height: 10),

                Text(

                  description,

                  style: const TextStyle(

                    color: Colors.white70,

                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          Container(

            width: 90,

            height: 90,

            decoration: BoxDecoration(

              color: Colors.white24,

              borderRadius:
                  BorderRadius.circular(25),
            ),

            child: const Icon(

              Icons.school_rounded,

              color: Colors.white,

              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}