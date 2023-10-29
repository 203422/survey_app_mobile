import "package:flutter/material.dart";

class SideItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const SideItem({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon});
}

const appSideItems = <SideItem>[
  
  SideItem(
      title: 'Encuestas',
      subTitle: 'Encuestas',
      link: '/dashboard',
      icon: Icons.home,
    ),

  SideItem(
      title: 'Usuarios',
      subTitle: 'Usuarios',
      link: '/usuarios',
      icon: Icons.account_circle,
    ),
    
];
