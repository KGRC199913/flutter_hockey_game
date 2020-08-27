import 'dart:math' as math;
import 'dart:ui';

import 'package:box2d_flame/box2d.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flame/box2d/box2d_game.dart';
import 'package:flame/box2d/contact_callbacks.dart';
import 'package:flame/box2d/viewport.dart';
import 'package:flame/gestures.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' as mat;

List<Wall> createBoundaries(Box2DComponent box) {
  final Viewport viewport = box.viewport;
  final Vector2 screenSize = Vector2(viewport.width, viewport.height);
  final Vector2 topLeft = (screenSize / 2) * -1;
  final Vector2 bottomRight = screenSize / 2;
  final Vector2 topRight = Vector2(bottomRight.x, topLeft.y);
  final Vector2 bottomLeft = Vector2(topLeft.x, bottomRight.y);

  return [
    Wall(topLeft, topRight, box),
    Wall(topRight, bottomRight, box),
    Wall(bottomRight, bottomLeft, box),
    Wall(bottomLeft, topLeft, box),
  ];
}

class Ground extends BodyComponent {
  final Vector2 tl;
  final Vector2 tr;
  final Vector2 bl;
  final Vector2 br;

  Ground(this.tl, this.tr, this.bl, this.br, Box2DComponent box) : super(box) {
    _createBody(tl, tr, bl, br);
  }

  void _createBody(Vector2 tl, Vector2 tr, Vector2 bl, Vector2 br) {
    final PolygonShape shape = PolygonShape();
    shape.setAsEdge(tl, tr);
    shape.setAsEdge(tl, bl);
    shape.setAsEdge(tr, br);
    shape.setAsEdge(bl, br);

    final fixtureDef = FixtureDef()
      ..shape = shape
      ..restitution = 0.0
      ..friction = 0.0;

    final bodyDef = BodyDef()
      ..setUserData(this) // To be able to determine object in collision
      ..position = Vector2.zero()
      ..type = BodyType.STATIC;

    body = world.createBody(bodyDef)..createFixtureFromFixtureDef(fixtureDef);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final Rect rect = Rect.fromPoints(Offset(tl.x, tl.y), Offset(br.x, br.y));
    final Paint paint = PaletteEntry(mat.Color(0xFF001122)).paint;
    canvas.drawRect(rect, paint);
  }
}

class Wall extends BodyComponent {
  Paint paint = BasicPalette.white.paint;
  final Vector2 start;
  final Vector2 end;

  Wall(this.start, this.end, Box2DComponent box) : super(box) {
    _createBody(start, end);
  }

  @override
  void renderPolygon(Canvas canvas, List<Offset> coordinates) {
    final start = coordinates[0];
    final end = coordinates[1];
    canvas.drawLine(start, end, paint);
  }

  void _createBody(Vector2 start, Vector2 end) {
    final PolygonShape shape = PolygonShape();
    shape.setAsEdge(start, end);

    final fixtureDef = FixtureDef()
      ..shape = shape
      ..restitution = 0.0
      ..friction = 0.1;

    final bodyDef = BodyDef()
      ..setUserData(this) // To be able to determine object in collision
      ..position = Vector2.zero()
      ..type = BodyType.STATIC;

    body = world.createBody(bodyDef)..createFixtureFromFixtureDef(fixtureDef);
  }
}

class Ball extends BodyComponent {
  Paint originalPaint, currentPaint;
  bool giveNudge = false;

  Ball(Vector2 position, Box2DComponent box) : super(box) {
    originalPaint = _randomPaint();
    currentPaint = originalPaint;
    final worldPosition = viewport.getScreenToWorld(position);
    _createBody(5.0, worldPosition);
  }

  Paint _randomPaint() {
    final rng = math.Random();
    return PaletteEntry(
      Color.fromARGB(
        100 + rng.nextInt(155),
        100 + rng.nextInt(155),
        100 + rng.nextInt(155),
        255,
      ),
    ).paint;
  }

  void _createBody(double radius, Vector2 position) {
    final CircleShape shape = CircleShape();
    shape.radius = radius;

    final fixtureDef = FixtureDef()
      ..shape = shape
      ..restitution = 1.0
      ..density = 1.0
      ..friction = 0.1;

    final bodyDef = BodyDef()
    // To be able to determine object in collision
      ..setUserData(this)
      ..position = position
      ..type = BodyType.DYNAMIC;

    body = world.createBody(bodyDef)..createFixtureFromFixtureDef(fixtureDef);
  }

  @override
  bool destroy() {
    // Implement your logic for when the component should be removed
    return false;
  }

  @override
  void renderCircle(Canvas c, Offset p, double radius) {
    final blue = const PaletteEntry(mat.Colors.blue).paint;
    c.drawCircle(p, radius, currentPaint);

    final angle = body.getAngle();
    final lineRotation =
    Offset(math.sin(angle) * radius, math.cos(angle) * radius);
    c.drawLine(p, p + lineRotation, blue);
  }

  @override
  void update(double t) {
    super.update(t);
    if (giveNudge) {
      body.applyLinearImpulse(Vector2(0, 10000), body.getLocalCenter(), true);
      giveNudge = false;
    }
  }
}

class Striker extends BodyComponent {
  Paint originalPaint, currentPaint;
  bool giveNudge = false;

  Striker(Vector2 position, Box2DComponent box) : super(box) {
    originalPaint = _randomPaint();
    currentPaint = originalPaint;
    final worldPosition = viewport.getScreenToWorld(position);
    _createBody(8.0, worldPosition);
  }

  Paint _randomPaint() {
    final rng = math.Random();
    return PaletteEntry(
      Color.fromARGB(
        100 + rng.nextInt(155),
        100 + rng.nextInt(155),
        100 + rng.nextInt(155),
        255,
      ),
    ).paint;
  }

  void _createBody(double radius, Vector2 position) {
    final CircleShape shape = CircleShape();
    shape.radius = radius;

    final fixtureDef = FixtureDef()
      ..shape = shape
      ..restitution = 1.0
      ..density = 1.0
      ..friction = 0.1;

    final bodyDef = BodyDef()
    // To be able to determine object in collision
      ..setUserData(this)
      ..position = position
      ..type = BodyType.DYNAMIC;

    body = world.createBody(bodyDef)..createFixtureFromFixtureDef(fixtureDef);
  }

  @override
  bool destroy() {
    // Implement your logic for when the component should be removed
    return false;
  }

  @override
  void renderCircle(Canvas c, Offset p, double radius) {
    final blue = const PaletteEntry(mat.Colors.blue).paint;
    c.drawCircle(p, radius, currentPaint);

    final angle = body.getAngle();
    final lineRotation =
    Offset(math.sin(angle) * radius, math.cos(angle) * radius);
    c.drawLine(p, p + lineRotation, blue);
  }

  @override
  void update(double t) {
    super.update(t);
    if (giveNudge) {
      body.applyLinearImpulse(Vector2(0, 10000), body.getLocalCenter(), true);
      giveNudge = false;
    }
  }
}

class WhiteBall extends Ball {
  WhiteBall(Vector2 position, Box2DComponent box) : super(position, box) {
    originalPaint = BasicPalette.white.paint;
    currentPaint = originalPaint;
  }
}

class BallContactCallback extends ContactCallback<Ball, Ball> {
  @override
  void begin(Ball ball1, Ball ball2, Contact contact) {
    if (ball1 is WhiteBall || ball2 is WhiteBall) {
      return;
    }
    if (ball1.currentPaint != ball1.originalPaint) {
      ball1.currentPaint = ball2.currentPaint;
    } else {
      ball2.currentPaint = ball1.currentPaint;
    }
  }

  @override
  void end(Ball ball1, Ball ball2, Contact contact) {}
}

class WhiteBallContactCallback extends ContactCallback<Ball, WhiteBall> {
  @override
  void begin(Ball ball, WhiteBall whiteBall, Contact contact) {
    ball.giveNudge = true;
  }

  @override
  void end(Ball ball, WhiteBall whiteBall, Contact contact) {}
}

class BallWallContactCallback extends ContactCallback<Ball, Wall> {
  @override
  void begin(Ball ball, Wall wall, Contact contact) {
    wall.paint = ball.currentPaint;
  }

  @override
  void end(Ball ball1, Wall wall, Contact contact) {}
}

class MyGame extends Box2DGame with TapDetector, PanDetector {
  Ball ball;
  Striker striker;
  Wall wall;
  Ground ground;
  MouseJoint mouseJoint;
  Body hitBody;
  Vector2 p;
  QueryCallback callback;
  bool isDragging;
  mat.BuildContext context;

  MyGame(Box2DComponent box, mat.BuildContext context) : super(box) {
    p = Vector2.zero();
    callback = _Callback((body) {
      hitBody = body;
    }, p);

    final boundaries = createBoundaries(box);
    boundaries.forEach(add);
    addContactCallback(BallContactCallback());
    addContactCallback(BallWallContactCallback());
    addContactCallback(WhiteBallContactCallback());

    final Viewport viewport = box.viewport;
    final Vector2 screenSize = Vector2(viewport.size.width, viewport.size.height);
    final Vector2 topLeft = (screenSize / 2) * -1;
    final Vector2 bottomRight = screenSize / 2;
    final Vector2 topRight = Vector2(bottomRight.x, topLeft.y);
    final Vector2 bottomLeft = Vector2(topLeft.x, bottomRight.y);

    ground = Ground(topLeft, topRight, bottomLeft, bottomRight, box);
    add(ground);

    Future.delayed(Duration(seconds: 1), () {
      add(Striker(Vector2(200, 200), box));
      add(Ball(Vector2(200, 300), box));
      int c = 0;
      box.components.forEach((component) {
        if (component is Ball) {
          ball = component;
        } else if (component is Wall) {
          ++c;
          if (c == 3) {
            wall = component;
          }
        } else if (component is Striker) {
          striker = component;
        }
      });
    });
    Future.delayed(Duration(seconds: 10), () {
      mat.Navigator.of(context).pushReplacement(mat.MaterialPageRoute(
          builder: (context) {
            return mat.Center(
              child: mat.Text("Game Finished"),
            );
          }
      ));
    });
  }

  @override
  void onTapDown(mat.TapDownDetails details) {
    super.onTapDown(details);
  }

  @override
  void onPanStart(mat.DragStartDetails details) {
    super.onPanStart(details);

    p.setFrom(Vector2(
        (details.globalPosition.dx - box.viewport.size.width / 2) * 100.0 / (box.viewport.size.width / 2),
        -((details.globalPosition.dy - box.viewport.size.height / 2) * 100.0 / (box.viewport.size.height / 2))));
    print(p);
    hitBody = null;
    this.box.world.queryAABB(
        callback, AABB.withVec2(Vector2(p.x, p.y), Vector2(p.x, p.y)));

    if (hitBody != null) {
      final mouseJointDef = MouseJointDef()
        ..maxForce = 100000000.0 * striker.body.mass
        ..bodyA = ground.body
        ..bodyB = hitBody
        ..collideConnected = true
        ..target.setFrom(p);

      hitBody.setAwake(true);
      mouseJoint = this.box.world.createJoint(mouseJointDef);
    }
  }

  @override
  void onPanUpdate(mat.DragUpdateDetails details) {
    super.onPanUpdate(details);
    p.setFrom(Vector2(
        (details.globalPosition.dx - box.viewport.size.width / 2) * 100.0 / (box.viewport.size.width / 2),
        -((details.globalPosition.dy - box.viewport.size.height / 2) * 100.0 / (box.viewport.size.height / 2))));
    mouseJoint?.setTarget(p);
  }

  @override
  void onPanEnd(mat.DragEndDetails details) {
    super.onPanEnd(details);
    if (mouseJoint != null) {
      this.box.world.destroyJoint(mouseJoint);
      mouseJoint = null;
      hitBody = null;
    }
  }
}

class MyBox2D extends Box2DComponent {
  MyBox2D() : super(scale: 4.0, gravity: 0);

  @override
  void initializeWorld() {}
}

class _Callback extends QueryCallback {
  Function setHitBody;
  Vector2 p;

  _Callback(this.setHitBody, this.p);

  @override
  bool reportFixture(Fixture fixture) {
    if (!fixture.testPoint(p)) {
      setHitBody(fixture.getBody());
      return false;
    } else {
      return true;
    }
  }
}
