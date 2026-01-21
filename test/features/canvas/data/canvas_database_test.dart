import 'dart:io';

import 'package:copyclip/src/features/canvas/data/canvas_adapter.dart';
import 'package:copyclip/src/features/canvas/data/canvas_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late CanvasDatabase db;
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
  });

  setUp(() async {
    // Reset singleton if possible, or just re-init
    if (Hive.isBoxOpen('canvas_notes'))
      await Hive.box<CanvasNote>('canvas_notes').close();
    if (Hive.isBoxOpen('canvas_folders'))
      await Hive.box<CanvasFolder>('canvas_folders').close();

    // Clear any existing boxes from disk
    await Hive.deleteBoxFromDisk('canvas_notes');
    await Hive.deleteBoxFromDisk('canvas_folders');

    db = CanvasDatabase();
    await db.init();
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk('canvas_notes');
    await Hive.deleteBoxFromDisk('canvas_folders');
  });

  test('CanvasDatabase initializes and creates default folder', () async {
    final folders = db.getAllFolders();
    expect(folders.length, 1);
    expect(folders.first.id, 'default');
    expect(folders.first.name, 'My Sketches');
  });

  test('CanvasDatabase saves and retrieves a note', () async {
    final note = CanvasNote(
      id: '1',
      title: 'Test Sketch',
      folderId: 'default',
      pages: [CanvasPage()],
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      backgroundColor: Colors.white,
    );

    await db.saveNote(note);

    final retrieved = db.getNote('1');
    expect(retrieved, isNotNull);
    expect(retrieved!.title, 'Test Sketch');
  });

  test('CanvasDatabase deletes a note', () async {
    final note = CanvasNote(
      id: '2',
      title: 'To Delete',
      folderId: 'default',
      pages: [],
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      backgroundColor: Colors.white,
    );

    await db.saveNote(note);
    await db.deleteNote('2');

    final retrieved = db.getNote('2');
    expect(retrieved!.isDeleted, true);

    // public getter filters deleted
    final notesInFolder = db.getNotesByFolder('default');
    expect(notesInFolder.any((n) => n.id == '2'), false);
  });
}
