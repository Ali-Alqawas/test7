// import 'package:flutter/material.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/theme_manager.dart';
// import '../../../core/widgets/offer_action_buttons.dart';
// import '../details/offer_details_screen.dart';

// // ============================================================================
// // شاشة جميع العروض (All Offers Screen)
// // ============================================================================
// class OffersScreen extends StatefulWidget {
//   const OffersScreen({super.key});

//   @override
//   State<OffersScreen> createState() => _OffersScreenState();
// }

// class _OffersScreenState extends State<OffersScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   // العروض المختلطة (عشوائية)
//   static final List<Map<String, dynamic>> _allOffers = [
//     {
//       "title": "ساعة رولكس ديتونا",
//       "storeName": "مجوهرات الفخامة",
//       "storeLogo": "https://i.pravatar.cc/150?img=11",
//       "image":
//           "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=500&q=80",
//       "price": "12,500\$",
//       "oldPrice": "15,000\$",
//       "discount": "17%",
//       "isFeatured": true,
//       "category": "مجوهرات",
//     },
//     {
//       "title": "سماعة ابل ايربودز برو",
//       "storeName": "اكسترا",
//       "storeLogo": "https://i.pravatar.cc/150?img=12",
//       "image":
//           "https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?auto=format&fit=crop&w=500&q=80",
//       "price": "199\$",
//       "oldPrice": "250\$",
//       "discount": "20%",
//       "isFeatured": false,
//       "category": "إلكترونيات",
//     },
//     {
//       "title": "حذاء رياضي نايك اير",
//       "storeName": "نايك ستور",
//       "storeLogo": "https://i.pravatar.cc/150?img=33",
//       "image":
//           "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=500&q=80",
//       "price": "120\$",
//       "oldPrice": "180\$",
//       "discount": "33%",
//       "isFeatured": true,
//       "category": "أزياء",
//     },
//     {
//       "title": "عطر شانيل بلو",
//       "storeName": "وجوه للعطور",
//       "storeLogo": "https://i.pravatar.cc/150?img=44",
//       "image":
//           "https://images.unsplash.com/photo-1528701800487-ad01fc8b1828?auto=format&fit=crop&w=500&q=80",
//       "price": "150\$",
//       "oldPrice": "200\$",
//       "discount": "25%",
//       "isFeatured": false,
//       "category": "عطور",
//     },
//     {
//       "title": "ماكينة قهوة ديلونجي",
//       "storeName": "ساكو",
//       "storeLogo": "https://i.pravatar.cc/150?img=12",
//       "image":
//           "https://images.unsplash.com/photo-1517068865886-443faf53e4fb?auto=format&fit=crop&w=500&q=80",
//       "price": "299\$",
//       "oldPrice": "350\$",
//       "discount": "15%",
//       "isFeatured": false,
//       "category": "أجهزة منزلية",
//     },
//     {
//       "title": "نظارة ريبان أصلية",
//       "storeName": "مغربي للبصريات",
//       "storeLogo": "https://i.pravatar.cc/150?img=12",
//       "image":
//           "https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=500&q=80",
//       "price": "95\$",
//       "oldPrice": "130\$",
//       "discount": "27%",
//       "isFeatured": true,
//       "category": "أزياء",
//     },
//     {
//       "title": "تيشيرت بولو كلاسيك",
//       "storeName": "سنتربوينت",
//       "storeLogo": "https://i.pravatar.cc/150?img=13",
//       "image":
//           "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=500&q=80",
//       "price": "25\$",
//       "oldPrice": "40\$",
//       "discount": "38%",
//       "isFeatured": false,
//       "category": "أزياء",
//     },
//     {
//       "title": "طقم عطور شرقية",
//       "storeName": "العربية للعود",
//       "storeLogo": "https://i.pravatar.cc/150?img=14",
//       "image":
//           "https://images.unsplash.com/photo-1594035910387-fea47794261f?auto=format&fit=crop&w=500&q=80",
//       "price": "85\$",
//       "oldPrice": "120\$",
//       "discount": "29%",
//       "isFeatured": false,
//       "category": "عطور",
//     },
//     {
//       "title": "MacBook Pro M3",
//       "storeName": "آبل ستور",
//       "storeLogo": "https://i.pravatar.cc/150?img=15",
//       "image":
//           "https://images.unsplash.com/photo-1517336714731-489689fd1ca4?auto=format&fit=crop&w=500&q=80",
//       "price": "1,200\$",
//       "oldPrice": "1,450\$",
//       "discount": "17%",
//       "isFeatured": true,
//       "category": "إلكترونيات",
//     },
//     {
//       "title": "وجبة برجر عائلي",
//       "storeName": "رويال برجر",
//       "storeLogo": "https://i.pravatar.cc/150?img=50",
//       "image":
//           "https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?auto=format&fit=crop&w=500&q=80",
//       "price": "45\$",
//       "oldPrice": "65\$",
//       "discount": "30%",
//       "isFeatured": false,
//       "category": "مطاعم",
//     },
//   ];

//   late List<Map<String, dynamic>> _displayedOffers;

//   @override
//   void initState() {
//     super.initState();
//     _displayedOffers = List.from(_allOffers)..shuffle();
//     _searchController.addListener(_onSearch);
//   }

//   void _onSearch() {
//     final query = _searchController.text.trim().toLowerCase();
//     setState(() {
//       if (query.isEmpty) {
//         _displayedOffers = List.from(_allOffers)..shuffle();
//       } else {
//         _displayedOffers = _allOffers.where((o) {
//           return o["title"].toString().toLowerCase().contains(query) ||
//               o["storeName"].toString().toLowerCase().contains(query) ||
//               o["category"].toString().toLowerCase().contains(query);
//         }).toList();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   // ==========================================
//   // نافذة الفلترة السفلية
//   // ==========================================
//   void _showFilterSheet(BuildContext context, bool isDarkMode) {
//     final Color sheetBg =
//         isDarkMode ? const Color(0xFF072A38) : AppColors.pureWhite;
//     final Color textColor =
//         isDarkMode ? AppColors.pureWhite : AppColors.lightText;
//     final Color chipBg =
//         isDarkMode ? AppColors.deepNavy : AppColors.lightBackground;

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => Directionality(
//         textDirection: TextDirection.rtl,
//         child: Container(
//           decoration: BoxDecoration(
//             color: sheetBg,
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
//           ),
//           padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // المقبض
//               Center(
//                   child: Container(
//                       width: 40,
//                       height: 4,
//                       decoration: BoxDecoration(
//                           color: AppColors.grey.withOpacity(0.3),
//                           borderRadius: BorderRadius.circular(2)))),
//               const SizedBox(height: 20),
//               // العنوان
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("فلترة العروض",
//                       style: TextStyle(
//                           color: textColor,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w900)),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                       setState(() {
//                         _displayedOffers = List.from(_allOffers)..shuffle();
//                       });
//                     },
//                     child: Text("إعادة ضبط",
//                         style: TextStyle(
//                             color: AppColors.goldenBronze.withOpacity(0.8),
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600)),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // --- فلتر التصنيف ---
//               Text("التصنيف",
//                   style: TextStyle(
//                       color: textColor.withOpacity(0.6),
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700)),
//               const SizedBox(height: 10),
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: [
//                   "الكل",
//                   "إلكترونيات",
//                   "أزياء",
//                   "عطور",
//                   "مطاعم",
//                   "أجهزة منزلية",
//                   "مجوهرات"
//                 ].map((cat) {
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                       setState(() {
//                         if (cat == "الكل") {
//                           _displayedOffers = List.from(_allOffers)..shuffle();
//                         } else {
//                           _displayedOffers = _allOffers
//                               .where((o) => o["category"] == cat)
//                               .toList();
//                         }
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 14, vertical: 8),
//                       decoration: BoxDecoration(
//                           color: chipBg,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                               color: AppColors.goldenBronze.withOpacity(0.3))),
//                       child: Text(cat,
//                           style: TextStyle(
//                               color: textColor,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600)),
//                     ),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 20),

//               // --- فلتر الترتيب ---
//               Text("الترتيب حسب",
//                   style: TextStyle(
//                       color: textColor.withOpacity(0.6),
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700)),
//               const SizedBox(height: 10),
//               _buildFilterOption(
//                   Icons.star_rounded, "المميزة أولاً", isDarkMode, textColor,
//                   () {
//                 Navigator.pop(context);
//                 setState(() {
//                   _displayedOffers = List.from(_allOffers)
//                     ..sort((a, b) => (b["isFeatured"] ? 1 : 0)
//                         .compareTo(a["isFeatured"] ? 1 : 0));
//                 });
//               }),
//               _buildFilterOption(Icons.trending_down_rounded, "الأقل سعراً",
//                   isDarkMode, textColor, () {
//                 Navigator.pop(context);
//                 setState(() {
//                   _displayedOffers = List.from(_allOffers);
//                 });
//               }),
//               _buildFilterOption(Icons.local_fire_department_rounded,
//                   "الأكبر خصماً", isDarkMode, textColor, () {
//                 Navigator.pop(context);
//                 setState(() {
//                   _displayedOffers = List.from(_allOffers);
//                 });
//               }),
//               _buildFilterOption(
//                   Icons.fiber_new_rounded, "الأحدث", isDarkMode, textColor, () {
//                 Navigator.pop(context);
//                 setState(() {
//                   _displayedOffers = List.from(_allOffers)..shuffle();
//                 });
//               }),
//               const SizedBox(height: 10),

//               // --- فلتر النوع ---
//               Text("النوع",
//                   style: TextStyle(
//                       color: textColor.withOpacity(0.6),
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700)),
//               const SizedBox(height: 10),
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: [
//                   _buildTypeChip("الكل", Icons.apps_rounded, chipBg, textColor,
//                       () {
//                     Navigator.pop(context);
//                     setState(() {
//                       _displayedOffers = List.from(_allOffers)..shuffle();
//                     });
//                   }),
//                   _buildTypeChip(
//                       "مميزة ⭐", Icons.star_rounded, chipBg, textColor, () {
//                     Navigator.pop(context);
//                     setState(() {
//                       _displayedOffers = _allOffers
//                           .where((o) => o["isFeatured"] == true)
//                           .toList();
//                     });
//                   }),
//                   _buildTypeChip(
//                       "عادية", Icons.grid_view_rounded, chipBg, textColor, () {
//                     Navigator.pop(context);
//                     setState(() {
//                       _displayedOffers = _allOffers
//                           .where((o) => o["isFeatured"] != true)
//                           .toList();
//                     });
//                   }),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterOption(IconData icon, String label, bool isDark,
//       Color textColor, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 6),
//         child: Row(
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                   color: AppColors.goldenBronze.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10)),
//               child: Icon(icon, color: AppColors.goldenBronze, size: 18),
//             ),
//             const SizedBox(width: 12),
//             Text(label,
//                 style: TextStyle(
//                     color: textColor,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600)),
//             const Spacer(),
//             Icon(Icons.arrow_back_ios_new_rounded,
//                 color: AppColors.grey.withOpacity(0.4), size: 14),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTypeChip(String label, IconData icon, Color chipBg,
//       Color textColor, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//         decoration: BoxDecoration(
//             color: chipBg,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: AppColors.goldenBronze.withOpacity(0.3))),
//         child: Row(mainAxisSize: MainAxisSize.min, children: [
//           Icon(icon, color: AppColors.goldenBronze, size: 16),
//           const SizedBox(width: 6),
//           Text(label,
//               style: TextStyle(
//                   color: textColor, fontSize: 12, fontWeight: FontWeight.w600)),
//         ]),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final Color bgColor =
//         isDarkMode ? AppColors.deepNavy : AppColors.lightBackground;

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: bgColor,
//         body: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(context, isDarkMode),
//               // قائمة العروض — عمودية
//               Expanded(
//                 child: _displayedOffers.isEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.search_off_rounded,
//                                 size: 60,
//                                 color: AppColors.goldenBronze.withOpacity(0.4)),
//                             const SizedBox(height: 16),
//                             Text("لا توجد نتائج",
//                                 style: TextStyle(
//                                     color: isDarkMode
//                                         ? AppColors.pureWhite
//                                         : AppColors.lightText,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w700)),
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         physics: const BouncingScrollPhysics(),
//                         padding: const EdgeInsets.fromLTRB(16, 5, 16, 100),
//                         itemCount: _displayedOffers.length,
//                         itemBuilder: (context, index) {
//                           return _buildOfferCard(
//                               _displayedOffers[index], isDarkMode);
//                         },
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ==========================================
//   // الهيدر: رجوع + عنوان + فلتر + ثيم
//   // ==========================================
//   Widget _buildHeader(BuildContext context, bool isDarkMode) {
//     final Color textColor =
//         isDarkMode ? AppColors.pureWhite : AppColors.lightText;

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
//       child: Column(
//         children: [
//           // الصف العلوي: رجوع + عنوان + ثيم
//           Row(
//             children: [
//               GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: isDarkMode
//                         ? const Color(0xFF072A38)
//                         : AppColors.pureWhite,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                         color: isDarkMode
//                             ? AppColors.goldenBronze.withOpacity(0.3)
//                             : Colors.grey.shade300),
//                   ),
//                   child: Icon(Icons.arrow_forward_ios_rounded,
//                       color: textColor, size: 18),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text("جميع العروض 🔥",
//                   style: TextStyle(
//                       color: textColor,
//                       fontSize: 24,
//                       fontWeight: FontWeight.w900)),
//               const SizedBox(width: 8),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 decoration: BoxDecoration(
//                   color: AppColors.goldenBronze.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                       color: AppColors.goldenBronze.withOpacity(0.3)),
//                 ),
//                 child: Text("${_displayedOffers.length}",
//                     style: const TextStyle(
//                         color: AppColors.goldenBronze,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold)),
//               ),
//               const Spacer(),
//               // أيقونة تبديل الثيم
//               GestureDetector(
//                 onTap: toggleGlobalTheme,
//                 child: Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color:
//                         isDarkMode ? AppColors.pureWhite : AppColors.deepNavy,
//                     borderRadius: BorderRadius.circular(14),
//                     boxShadow: [
//                       BoxShadow(
//                           color:
//                               (isDarkMode ? Colors.black : AppColors.deepNavy)
//                                   .withOpacity(0.15),
//                           blurRadius: 8,
//                           offset: const Offset(0, 3))
//                     ],
//                   ),
//                   child: Icon(
//                       isDarkMode
//                           ? Icons.wb_sunny_rounded
//                           : Icons.nightlight_round,
//                       color: AppColors.goldenBronze,
//                       size: 20),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),
//           // بحث + أيقونة فلتر
//           Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: isDarkMode
//                         ? const Color(0xFF072A38)
//                         : AppColors.pureWhite,
//                     borderRadius: BorderRadius.circular(25),
//                     border: Border.all(
//                         color: isDarkMode
//                             ? AppColors.goldenBronze.withOpacity(0.3)
//                             : AppColors.goldenBronze,
//                         width: 1.2),
//                     boxShadow: [
//                       if (!isDarkMode)
//                         BoxShadow(
//                             color: AppColors.goldenBronze.withOpacity(0.1),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4))
//                     ],
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   child: Row(children: [
//                     Icon(Icons.search_rounded,
//                         color: isDarkMode
//                             ? AppColors.warmBeige
//                             : AppColors.goldenBronze,
//                         size: 20),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: TextField(
//                         controller: _searchController,
//                         style: TextStyle(
//                             color: isDarkMode
//                                 ? AppColors.pureWhite
//                                 : AppColors.lightText,
//                             fontSize: 14),
//                         decoration: InputDecoration(
//                           hintText: "ابحث عن عرض...",
//                           hintStyle: TextStyle(
//                               color: isDarkMode
//                                   ? AppColors.grey
//                                   : AppColors.lightText.withOpacity(0.5),
//                               fontSize: 13),
//                           border: InputBorder.none,
//                           isDense: true,
//                           contentPadding: EdgeInsets.zero,
//                         ),
//                       ),
//                     ),
//                     if (_searchController.text.isNotEmpty)
//                       GestureDetector(
//                         onTap: () => _searchController.clear(),
//                         child: const Icon(Icons.close_rounded,
//                             color: AppColors.grey, size: 18),
//                       ),
//                   ]),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               // أيقونة الفلتر
//               GestureDetector(
//                 onTap: () => _showFilterSheet(context, isDarkMode),
//                 child: Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: AppColors.goldenBronze,
//                     borderRadius: BorderRadius.circular(14),
//                     boxShadow: [
//                       BoxShadow(
//                           color: AppColors.goldenBronze.withOpacity(0.3),
//                           blurRadius: 8,
//                           offset: const Offset(0, 3))
//                     ],
//                   ),
//                   child: const Icon(Icons.tune_rounded,
//                       color: Colors.white, size: 22),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================================
//   // كارت العرض العمودي
//   // ==========================================
//   Widget _buildOfferCard(Map<String, dynamic> offer, bool isDarkMode) {
//     final Color cardColor =
//         isDarkMode ? const Color(0xFF072A38) : AppColors.pureWhite;
//     final Color borderColor = isDarkMode
//         ? AppColors.goldenBronze.withOpacity(0.2)
//         : Colors.grey.shade200;
//     final bool isFeatured = offer["isFeatured"] ?? false;

//     return GestureDetector(
//         onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => OfferDetailsScreen(
//                     offerData: offer, offerType: OfferDetailType.standard))),
//         child: Container(
//           margin: const EdgeInsets.only(bottom: 14),
//           decoration: BoxDecoration(
//             color: cardColor,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: isFeatured
//                   ? AppColors.goldenBronze.withOpacity(isDarkMode ? 0.6 : 1.0)
//                   : borderColor,
//               width: isFeatured ? 1.5 : 1.0,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: isFeatured
//                     ? AppColors.goldenBronze
//                         .withOpacity(isDarkMode ? 0.1 : 0.15)
//                     : Colors.black.withOpacity(isDarkMode ? 0.2 : 0.04),
//                 blurRadius: 12,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(19),
//             child: Row(
//               children: [
//                 // الصورة (يمين)
//                 SizedBox(
//                   width: 130,
//                   height: 140,
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       Image.network(offer["image"], fit: BoxFit.cover),
//                       Positioned(
//                         top: 8,
//                         right: 8,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 7, vertical: 3),
//                           decoration: BoxDecoration(
//                               color: AppColors.error,
//                               borderRadius: BorderRadius.circular(6)),
//                           child: Text("${offer["discount"]}-",
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold)),
//                         ),
//                       ),
//                       if (isFeatured)
//                         Positioned(
//                           bottom: 8,
//                           right: 8,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 6, vertical: 3),
//                             decoration: BoxDecoration(
//                                 color: AppColors.goldenBronze,
//                                 borderRadius: BorderRadius.circular(6)),
//                             child: const Text("مميز ⭐",
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 9,
//                                     fontWeight: FontWeight.bold)),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 // التفاصيل
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Row(children: [
//                           Container(
//                             padding: const EdgeInsets.all(1.5),
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                     color: AppColors.goldenBronze
//                                         .withOpacity(0.5))),
//                             child: CircleAvatar(
//                                 radius: 10,
//                                 backgroundColor: AppColors.lightBackground,
//                                 backgroundImage:
//                                     NetworkImage(offer["storeLogo"])),
//                           ),
//                           const SizedBox(width: 6),
//                           Expanded(
//                               child: Text(offer["storeName"],
//                                   style: const TextStyle(
//                                       color: AppColors.goldenBronze,
//                                       fontSize: 11,
//                                       fontWeight: FontWeight.w700),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis)),
//                         ]),
//                         const SizedBox(height: 8),
//                         Text(offer["title"],
//                             style: TextStyle(
//                                 color: isDarkMode
//                                     ? AppColors.pureWhite
//                                     : AppColors.lightText,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w900,
//                                 height: 1.3),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis),
//                         const SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(offer["price"],
//                                       style: const TextStyle(
//                                           color: AppColors.goldenBronze,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w900)),
//                                   Text(offer["oldPrice"],
//                                       style: const TextStyle(
//                                           color: AppColors.grey,
//                                           fontSize: 11,
//                                           decoration:
//                                               TextDecoration.lineThrough)),
//                                 ]),
//                             OfferActionButtons(
//                                 isDarkMode: isDarkMode,
//                                 offerId: "ALL_${offer["title"]}"),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }

import 'package:flutter/material.dart';
import 'dart:async'; // من أجل الـ Debouncer للبحث
import '../../../core/network/api_service.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/widgets/offer_action_buttons.dart';
import '../../../core/widgets/offer_filter_sheet.dart'; // استدعاء ملف الفلتر المستقل
import '../details/offer_details_screen.dart';

// ============================================================================
// شاشة جميع العروض (All Offers Screen) - مربوطة بالـ API
// ============================================================================
class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<Map<String, dynamic>> _offers = [];
  bool _isLoading = true;

  // حفظ أوامر الفلترة الحالية (Parameters)
  Map<String, String> _currentFilters = {};

  @override
  void initState() {
    super.initState();
    _fetchOffers();

    // مراقبة شريط البحث مع تأخير زمني (Debounce) لعدم إرهاق السيرفر
    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (_currentFilters['search'] != _searchController.text) {
          _currentFilters['search'] = _searchController.text;
          _fetchOffers();
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ==========================================
  // جلب البيانات من الباك إند
  // ==========================================
  Future<void> _fetchOffers() async {
    setState(() => _isLoading = true);
    try {
      // إرسال الطلب مع تمرير فلاتر البحث والترتيب
      final data = await _api.get(
        ApiConstants.products,
        queryParams: _currentFilters,
        requiresAuth: false,
      );

      final List rawOffers =
          data is Map ? (data['results'] ?? []) : (data is List ? data : []);

      if (mounted) {
        setState(() {
          _offers = rawOffers.map<Map<String, dynamic>>((product) {
            var images = product['images'] as List?;
            String imageUrl = (images != null && images.isNotEmpty)
                ? ApiConstants.resolveImageUrl(
                    images[0]['image_url']?.toString())
                : ApiConstants.resolveImageUrl(
                    product['image_url']?.toString() ??
                        product['image']?.toString());

            String storeName = product['store_name']?.toString() ?? 'متجر';
            String storeLogo = (product['logo'] ?? product['store_logo']) !=
                    null
                ? ApiConstants.resolveImageUrl(
                    (product['logo'] ?? product['store_logo']).toString())
                : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(storeName)}&background=B8860B&color=fff';

            double price = double.tryParse(product['new_price']?.toString() ??
                    product['price']?.toString() ??
                    '0') ??
                0;
            double oldPrice =
                double.tryParse(product['old_price']?.toString() ?? '0') ?? 0;
            String discount = '';
            if (oldPrice > price && oldPrice > 0) {
              discount =
                  '${((oldPrice - price) / oldPrice * 100).toStringAsFixed(0)}%';
            }

            return {
              "id": (product['product_id'] ?? product['id'] ?? '').toString(),
              "title": product['title'] ?? 'بدون عنوان',
              "storeName": storeName,
              "storeLogo": storeLogo,
              "image": imageUrl,
              "price": "$price\$",
              "oldPrice": oldPrice > 0 ? "$oldPrice\$" : "",
              "discount": discount.isNotEmpty ? discount : null,
              "isFeatured": product['is_featured'] ?? false,
              "is_liked": product['is_liked'] ?? false,
              "is_favorited": product['is_favorited'] ?? false,
              "original_data": product,
            };
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ في جلب جميع العروض: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ==========================================
  // استدعاء نافذة الفلتر المستقلة
  // ==========================================
  void _openFilterSheet(bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => OfferFilterSheet(
        isDarkMode: isDarkMode,
        initialFilters: _currentFilters, // نمرر الفلاتر الحالية
        onApply: (newFilters) {
          // عندما يضغط المستخدم على "تطبيق"، نستقبل الفلاتر الجديدة ونجلب البيانات
          setState(() {
            _currentFilters = newFilters;
            // نحافظ على كلمة البحث إن وجدت
            if (_searchController.text.isNotEmpty) {
              _currentFilters['search'] = _searchController.text;
            }
          });
          _fetchOffers();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor =
        isDarkMode ? AppColors.deepNavy : AppColors.lightBackground;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDarkMode),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.goldenBronze))
                    : _offers.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off_rounded,
                                    size: 60,
                                    color: AppColors.goldenBronze
                                        .withOpacity(0.4)),
                                const SizedBox(height: 16),
                                Text("لا توجد نتائج مطابقة لطلبك",
                                    style: TextStyle(
                                        color: isDarkMode
                                            ? AppColors.pureWhite
                                            : AppColors.lightText,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 5, 16, 100),
                            itemCount: _offers.length,
                            itemBuilder: (context, index) {
                              return _buildOfferCard(
                                  _offers[index], isDarkMode);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    final Color textColor =
        isDarkMode ? AppColors.pureWhite : AppColors.lightText;
    final cardC = isDarkMode ? const Color(0xFF072A38) : AppColors.pureWhite;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF072A38)
                        : AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isDarkMode
                            ? AppColors.goldenBronze.withOpacity(0.3)
                            : Colors.grey.shade300),
                  ),
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      color: textColor, size: 18),
                ),
              ),
              const SizedBox(width: 12),
              Text("جميع العروض 🔥",
                  style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w900)),
              const SizedBox(width: 8),
              if (!_isLoading)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.goldenBronze.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.goldenBronze.withOpacity(0.3)),
                  ),
                  child: Text("${_offers.length}",
                      style: const TextStyle(
                          color: AppColors.goldenBronze,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              const Spacer(),
              GestureDetector(
                onTap: toggleGlobalTheme,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color:
                        isDarkMode ? AppColors.pureWhite : AppColors.deepNavy,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color:
                              (isDarkMode ? Colors.black : AppColors.deepNavy)
                                  .withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: Icon(
                      isDarkMode
                          ? Icons.wb_sunny_rounded
                          : Icons.nightlight_round,
                      color: AppColors.goldenBronze,
                      size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: cardC,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                        color: isDarkMode
                            ? AppColors.goldenBronze.withOpacity(0.3)
                            : AppColors.goldenBronze,
                        width: 1.2),
                    boxShadow: [
                      if (!isDarkMode)
                        BoxShadow(
                            color: AppColors.goldenBronze.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(children: [
                    Icon(Icons.search_rounded,
                        color: isDarkMode
                            ? AppColors.warmBeige
                            : AppColors.goldenBronze,
                        size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "ابحث عن عرض...",
                          hintStyle: TextStyle(
                              color: isDarkMode
                                  ? AppColors.grey
                                  : AppColors.lightText.withOpacity(0.5),
                              fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          _currentFilters.remove('search');
                          _fetchOffers();
                        },
                        child: const Icon(Icons.close_rounded,
                            color: AppColors.grey, size: 18),
                      ),
                  ]),
                ),
              ),
              const SizedBox(width: 10),
              // ربط أيقونة الفلتر بالملف الجديد
              GestureDetector(
                onTap: () => _openFilterSheet(isDarkMode),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.goldenBronze,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.goldenBronze.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: const Icon(Icons.tune_rounded,
                      color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer, bool isDarkMode) {
    final Color cardColor =
        isDarkMode ? const Color(0xFF072A38) : AppColors.pureWhite;
    final Color borderColor = isDarkMode
        ? AppColors.goldenBronze.withOpacity(0.2)
        : Colors.grey.shade200;
    final bool isFeatured = offer["isFeatured"] ?? false;

    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OfferDetailsScreen(
                    offerData: offer["original_data"] ?? offer,
                    offerType: OfferDetailType.standard))),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isFeatured
                  ? AppColors.goldenBronze.withOpacity(isDarkMode ? 0.6 : 1.0)
                  : borderColor,
              width: isFeatured ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isFeatured
                    ? AppColors.goldenBronze
                        .withOpacity(isDarkMode ? 0.1 : 0.15)
                    : Colors.black.withOpacity(isDarkMode ? 0.2 : 0.04),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: Row(
              children: [
                SizedBox(
                  width: 130,
                  height: 140,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(offer["image"], fit: BoxFit.cover),
                      if (offer["discount"] != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(6)),
                            child: Text("${offer["discount"]}-",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      if (isFeatured)
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                                color: AppColors.goldenBronze,
                                borderRadius: BorderRadius.circular(6)),
                            child: const Text("مميز ⭐",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.all(1.5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.goldenBronze
                                        .withOpacity(0.5))),
                            child: CircleAvatar(
                                radius: 10,
                                backgroundColor: AppColors.lightBackground,
                                backgroundImage:
                                    NetworkImage(offer["storeLogo"])),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                              child: Text(offer["storeName"],
                                  style: const TextStyle(
                                      color: AppColors.goldenBronze,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis)),
                        ]),
                        const SizedBox(height: 8),
                        Text(offer["title"],
                            style: TextStyle(
                                color: isDarkMode
                                    ? AppColors.pureWhite
                                    : AppColors.lightText,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                height: 1.3),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(offer["price"],
                                      style: const TextStyle(
                                          color: AppColors.goldenBronze,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900)),
                                  if (offer["oldPrice"].isNotEmpty)
                                    Text(offer["oldPrice"],
                                        style: const TextStyle(
                                            color: AppColors.grey,
                                            fontSize: 11,
                                            decoration:
                                                TextDecoration.lineThrough)),
                                ]),
                            // تمرير الـ ID الحقيقي لزر المفضلة
                            OfferActionButtons(
                              isDarkMode: isDarkMode,
                              offerId: offer["id"].toString(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
